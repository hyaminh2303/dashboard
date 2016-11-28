class DailyTracking < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :platform
  belongs_to :campaign_ads_group, foreign_key: 'group_id'

  attr_accessor :override
  attr_accessor :sum

  validates :date, presence: true
  validate :date_between_campaign_start_end
  validates_presence_of :campaign_ads_group, if: :has_ads_group?

  validates :platform, :views, :clicks, :spend, presence: true # views, clicks, spend used when update
  validates :views, :numericality => { :greater_than => 0 }, if: :clicks_greater_than_zero?
  validates :clicks, :numericality => { :greater_than => 0 }, if: :views_greater_than_zero?

  validate :unique_log

  scope :monthly_campaign, ->{ joins(:campaign).where(campaigns: { expire_at: START_DATE.call..END_DATE.call}) }

  # Usage
  #   DailyTracking.monthly_campaign.sum_by_platform
  #   Campaign.monthly_campaign[].daily_trackings.sum_by_platform
  scope :sum_by_platform, ->{ select('campaign_id, platform_id, SUM(views) as views, SUM(clicks) as clicks, SUM(spend) as spend').group('campaign_id, platform_id')}

  scope :stats, ->(from, to, group_by_date = false) {
    query = select('date, COALESCE(SUM(views), 0) AS views,
                          COALESCE(SUM(clicks), 0) AS clicks,
                          COALESCE(SUM(spend), 0) as budget_spent')
      .where(date: from.beginning_of_day..to.end_of_day)
    query = query.group(:date).order(date: :asc) if group_by_date
    query
  }

  scope :actual_spend, ->(campaign_id){ select('SUM(spend) as spend').where(campaign_id: campaign_id).group('campaign_id') }

  def clicks_greater_than_zero?
    clicks == 0
  end

  def views_greater_than_zero?
    views == 0
  end

  def has_ads_group?
    self.campaign.has_ads_group?
  end

  # Custom validation
  def unique_log
    if self.new_record?

      condition = {:campaign_id => campaign_id, :platform_id => platform_id, :date => date}
      if self.campaign.has_ads_group
        condition[:group_id] = group_id
      end

      unless DailyTracking.where(condition).count == 0
        errors.add(:daily_tracking, I18n.t('models.daily_tracking.validate.already_add'))
      end
    end
  end

  # validate date
  def date_between_campaign_start_end
    if date.nil? || date < campaign.active_at || date > campaign.expire_at
      errors.add(:campaign, I18n.t('models.daily_tracking.validate.not_running_date'))
    end
  end

  # Callback functions
  after_initialize do
    if self.new_record?
      # This used for create new
      self.views = 0 if self.views.blank?
      self.clicks = 0 if self.clicks.blank?
      self.spend = 0 if self.spend.blank?
    end
  end

  def ctr
    if views.present? and views > 0
      (clicks.to_f / views.to_f) * 100 rescue 0
    else
      0
    end
  end

  def ecpm
    Currency.usd(views == 0 ? nil : spend / views * 1000, :USD).to_s rescue 0
  end

  def ecpc
    Currency.usd(clicks == 0 ? nil : spend / clicks, :USD).to_s rescue 0
  end
end
