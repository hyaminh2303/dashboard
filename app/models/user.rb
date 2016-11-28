class User < ActiveRecord::Base
  # Association
  belongs_to :role
  has_many :notified_campaigns, foreign_key: :user_notify_id, class_name: 'Campaign'
  has_one :agency
  delegate :can_see_detail_campaign?, to: :agency, prefix: true, allow_nil: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  def super_admin?
    role && role.super_admin
  end

  def admin?
    role && role.admin?
  end

  def active?
    agency = Agency.find_by_user_id(id)
    agency.nil? || (!agency.nil? && agency.enabled)
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    if active?
      super
    else
      :inactive
    end
  end

  def self.generate_password
    SecureRandom.hex(6)
  end

  def is_agency?
    a = agency
    a.nil? ? false : a.is_agency? and role_id == Figaro.env.agency_role_id.to_i
  end

  def is_client?
    a = agency
    a.nil? ? false : a.is_client? and role_id == Figaro.env.agency_role_id.to_i
  end

  def is_agency_or_client?
    role_id == Role.agency.id
  end

  # def agency
  #   Agency.find_by_user_id(id)
  # end
end
