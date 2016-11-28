class Agency < ActiveRecord::Base

  # Associations
  belongs_to :user
  has_many :campaigns

  has_many :clients, class_name: 'Agency', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :agency, class_name: 'Agency', foreign_key: 'parent_id'
  belongs_to :currency

  delegate :name, to: :currency, prefix: true

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  scope :all_agencies, -> { where parent_id: nil}
  scope :all_clients, -> { where.not parent_id: nil}
  scope :channel, -> (channel_type) { where(channel: channel_type) }

  # region filter agencies & clients
  scope :filter_agencies, ->(filter) {
    where_str = 'parent_id IS NULL'
    search_str = self.filter_search_string filter

    unless search_str.empty?
      where_str += " AND (#{search_str})"
    end

    # Search for children & get its parent_id
    include_ids = self.filter_get_include_ids search_str
    unless include_ids.length == 0
      where_str = "(#{where_str}) OR id IN (#{include_ids.join(', ')})"
    end

    Rails.logger.info where_str

    where where_str
  }

  scope :filter_clients, ->(parent_id, filter) {
    search_str = self.filter_search_string filter

    # If no search query and agency id not include in child search, then display all
    unless search_str.empty?
      include_ids = self.filter_get_include_ids search_str
      if include_ids.include?(parent_id)
        return where(search_str)
      end
    end

    all
  }

  def self.filter_search_string(filter)
    search_str = ''
    unless filter.nil?
      search_str += "name like '%#{filter[:name]}%'" unless filter[:name].nil?
      search_str += "#{search_str.empty? ? '' : ' AND '}email like '%#{filter[:email]}%'" unless filter[:email].nil?
      search_str += "#{search_str.empty? ? '' : ' AND '}country_code = '#{filter[:country_code]}'" unless filter[:country_code].nil?
    end
    search_str
  end

  def self.filter_get_include_ids(search_string)
    search_string.empty? ? [] : Agency.all_clients.select(:parent_id).where(search_string).distinct.map {|a| a.parent_id}
  end

  def self.all_channels
    ['Direct', 'Sales Partner', 'Agency']
  end
  # endregion

  # Validations
  validates :name, presence: true
  validates :contact_name, presence: true
  validates :country_code, presence: true
  validates :email, presence: true, email: true
  validates :contact_email, presence: true, email: true
  validates :billing_email, email: true, allow_blank: true
  validates :contact_email, email: true, allow_blank: false
  validate :unique_email

  # Custom validation methods
  def unique_email
    if new_record? or email_changed?
      unless User.find_by(email: email).nil? or Agency.find_by(email: email).nil?
        errors.add(:email, I18n.t('errors.messages.already_registered'))
      end
    end
  end

  # Callback functions
  after_create do
    pwd = User.generate_password
    user = User.new(name: name, email: email, password: pwd, password_confirmation: pwd, role_id: Figaro.env.agency_role_id.to_i)
    user.save
    update_attribute(:user, user)
  end

  after_update do
    unless user.nil?
      user.update_column(:email, email)
    end
  end

  after_destroy do
    unless user.nil?
      user.destroy
    end
  end

  # Helper methods
  def country
    Country.new(country_code)
  end

  def country_display_name
    c = country
    "#{c.name} (#{c.alpha2})"
  end

  def is_agency?
    parent_id.nil?
  end

  def is_client?
    !parent_id.nil?
  end

  def can_see_detail_campaign?
    is_agency? || !hide_finance
  end
end
