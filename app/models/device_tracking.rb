class DeviceTracking < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :campaign_ads_group
  validates :date_range, presence: true
  validate :date_between_campaign_start_end

  validates :campaign, :views, :clicks, :number_of_device_ids, :frequency_cap, presence: true
  # validates_presence_of :campaign_ads_group, if: :has_ads_group?

  validate :unique_log

  scope :by_date, ->(date) { where(date: date)}
  scope :select_by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) if campaign_id.to_i > 0 }
  scope :select_in_period, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :belong_to, ->(user) { joins(:campaign).where(campaigns: {agency_id: user.agency.id}) if (user.present? && user.is_agency_or_client?)}

  #------------------------------- begin instances ---------------------------------#
  # Custom validation
  def unique_log
    if self.new_record?
      unless DeviceTracking.where(:campaign_id => campaign_id, :campaign_ads_group_id => campaign_ads_group_id, :date => date).count == 0
        errors.add(:device_tracking, I18n.t('models.device_tracking.validate.already_add'))
      end
    end
  end

  # validate date
  def date_between_campaign_start_end
    if date.nil? || date < campaign.active_at || date > campaign.expire_at
      errors.add(:campaign, I18n.t('models.device_tracking.validate.not_running_date'))
    end
  end

  def has_ads_group?
    self.campaign.has_ads_group?
  end
end
