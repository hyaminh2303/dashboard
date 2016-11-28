class OsTracking < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :operating_system
  validates :date, presence: true

  validates :campaign, :operating_system, :views, :clicks, presence: true # :views, :clicks used when update


  validate :unique_log

  scope :by_date, ->(date) { where(date: date)}
  scope :select_by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) if campaign_id.to_i > 0 }
  scope :select_in_period, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :belong_to, ->(user) { joins(:campaign).where(campaigns: {agency_id: user.agency.id}) if (user.present? && user.is_agency_or_client?)}

  #------------------------------- begin instances ---------------------------------#
  # Custom validation
  def unique_log
    if self.new_record?
      unless OsTracking.where(:campaign_id => campaign_id, :operating_system_id => operating_system_id, :date => date).count == 0
        errors.add(:os_tracking, I18n.t('models.os_tracking.validate.already_add'))
      end
    end
  end

  # validate date - no need for os trackings
  def date_between_campaign_start_end
    if date.nil? || date < campaign.active_at || date > campaign.expire_at
      errors.add(:campaign, I18n.t('models.os_tracking.validate.not_running_date'))
    end
  end
end
