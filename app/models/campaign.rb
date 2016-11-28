class Campaign < ActiveRecord::Base

  include RailsSettings::Extend
  include CampaignHealth

  mount_uploader :signed_io, SignedIoUploader

  monetize :unit_price_cents, as: 'unit_price', with_model_currency: :unit_price_currency

  STATUSES  = [
      LIVE  = 'live',
      PENDING = 'pending',
      COMPLETED = 'completed'
  ]

  CAMPAIGN_TYPES = %i{CPM CPC}

  PERIODS = {
      today:  [Date.today, Date.today],
      yesterday: [Date.yesterday, Date.yesterday],
      this_week: [Date.today.at_beginning_of_week, Date.today],
      last_week: [1.week.ago.to_date, Date.today.at_beginning_of_week],
      last_7_days: [7.day.ago.to_date, Date.today],
      this_month: [Date.today.at_beginning_of_month, Date.today],
      last_month: [1.month.ago.to_date, Date.today]
  }

  # Associations
  belongs_to :agency
  belongs_to :user
  belongs_to :advertiser
  belongs_to :user_notify, class_name: 'User'

  has_many :daily_trackings, dependent: :destroy
  has_many :location_trackings, dependent: :destroy
  has_many :campaign_ads_groups, dependent: :destroy
  has_many :os_trackings, dependent: :destroy
  has_many :app_trackings, dependent: :destroy
  has_many :creative_trackings, dependent: :destroy
  has_many :device_trackings, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :advertiser_name, presence: true
  validates :unit_price, presence: true
  validates :active_at, presence: true
  validates :expire_at, presence: true
  validates :target_click, presence: {if: :CPC?}, numericality: {only_integer: true, greater_than: 0, if: :CPC?}
  validates :target_impression, presence: {if: :CPM?}, numericality: {only_integer: true, greater_than: 0, if: :CPM?}
  validates :discount, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :bonus_impression, numericality: {only_integer: true}
  validate :active_at_must_less_than_expire_at
  validate :discount_or_bonus_impression
  validate :target_per_adgroup

  # Custom validation methods
  def target_per_adgroup
    unless has_ads_group
      errors.add(:target_per_ad_group, "is enabled, please enable has_ads_group") if target_per_ad_group
    end
  end

  def active_at_cannot_be_in_the_past
    errors.add(:active_at, "can't be in the past") if (!active_at.blank? and active_at < Date.today and self.new_record?)
  end

  def active_at_must_less_than_expire_at
    errors.add(:active_at, "can't be greater than expire at") if (!active_at.blank? and !expire_at.blank? and active_at > expire_at)
  end

  def discount_or_bonus_impression
      errors.add(:campaign, "discount and bonus impression can't co-exist") if ((!discount.blank? and discount > 0) and (!bonus_impression.blank? and bonus_impression > 0))
  end

  scope :belong_to, ->(user) {
    if (user.present? && user.is_agency_or_client?)
      if user.is_client?
        where(agency_id: user.agency.id)
      else
        where("agency_id = #{user.agency.id} OR agency_id in (SELECT id from agencies WHERE parent_id = #{user.agency.id})")
      end
    end
  }
  scope :search_name, ->(name){ where("name LIKE '%#{name}%'") if name.present? }
  scope :overview, ->{ joins("LEFT JOIN #{DailyTracking.table_name} ON #{DailyTracking.table_name}.campaign_id = #{Campaign.table_name}.id LEFT JOIN #{Agency.table_name} ON #{Agency.table_name}.id = #{Campaign.table_name}.agency_id").select("#{Campaign.table_name}.*, #{Agency.table_name}.name as agency_name, #{Agency.table_name}.parent_id as parent_id , SUM(views) as views, SUM(clicks) as clicks").group("#{Campaign.table_name}.id") }
  scope :live, -> { where('CURDATE() BETWEEN active_at AND expire_at') }
  scope :live_recently, -> { where('(active_at < CURDATE() AND CURDATE() <= expire_at) OR (expire_at = DATE_SUB(CURDATE(),INTERVAL 1 DAY))') }
  scope :incoming, -> { where('CURDATE() <= active_at') }
  scope :monthly_campaign, ->{ where(expire_at: START_DATE.call..END_DATE.call) }

  def self.order_with_default(order_field, sort_type)
    order_fields = ['active_at DESC', :name, :id]
    order_fields.prepend "#{order_field} #{sort_type}" if order_field.present?
    order(order_fields)
  end

  # Helper methods
  def unit_price_in_usd_as_money
    Money.new(unit_price_in_usd)
  end

  # @deprecated Please use {#media_budget_as_money} instead
  def budget_as_money
    Money.new(budget)
  end

  def development_fee_as_money
    (development_fee? ? development_fee : 0.0).to_money(:USD)
  end

  def media_budget_as_money
    Money.new(budget)
  end

  def total_budget_as_money
    Money.new(total_budget)
  end

  def total_budget
    budget + (development_fee || 0) * 100
  end

  def discount?
    discount.present? and discount > 0.0
  end

  def development_fee?
    !(development_fee.nil? or development_fee == 0.0)
  end

  # Static function
  def self.budget_after_discount(budget, discount)
    budget * (1 - discount / 100)
  end

  def bonus_impression?
    CPM? and bonus_impression.present? and bonus_impression > 0.0
  end

  # Static function
  def self.budget_after_bonus_impression(target_impression, bonus_impression, unit_price_in_usd)
    unit_price_in_usd * ((target_impression - bonus_impression) / 1000)
  end

  def budget_spent
    if has_attribute?(:budget_spent_cents)
      Money.new(budget_spent_cents)
    else
      accumulated = (CPM? and !views.blank?) ? views : clicks
      if accumulated != 0
        development_fee? ? Money.new(1.0 * budget / target * accumulated) : Money.new(total_budget.to_f / target * accumulated)
      else
        Money.new(0)
      end
    end
  end

  def self.actual_budget(params)
    price = params[:price].to_f
    currency = params[:currency]
    campaign_type = params[:campaign_type]
    target_impression = params[:target_impression].to_f
    target_click = params[:target_click].to_f
    exchange_rate = params[:exchange_rate].to_f
    discount = params[:discount].to_f
    bonus_impression = params[:bonus_impression].to_f

    # Get media budget without development fee

    unit_price_in_usd = Currency.usd(price, currency).to_f
    target = campaign_type == 'CPM' ? target_impression / 1000 : target_click

    if exchange_rate != 0
      unit_price_in_usd = price * exchange_rate
    else
      exchange_rate = Currency.usd(price, currency).bank.get_rate(params[:currency], Money.default_currency).to_f
    end

    budget =  unit_price_in_usd * target

    if discount != 0
      actual_budget = self.budget_after_discount budget, discount
    elsif bonus_impression != 0
      actual_budget = self.budget_after_bonus_impression target_impression, bonus_impression, unit_price_in_usd
    else
      actual_budget = budget
    end

    {
        exchange_rate: exchange_rate,
        unit_price_in_usd: unit_price_in_usd,
        budget: budget,
        actual_budget: actual_budget
    }
  end

  def actual_budget
    budget_as_money
  end

  def actual_spend
    data = DailyTracking.actual_spend self.id
    data.first.spend.to_f
  end

  def actual_budget_in_us
    unit_price = self.unit_price_in_usd.to_f / 100.0
    if self.campaign_type == :CPM
      unit_price * (self.daily_trackings.sum('views') / 1000.0)
    else
      unit_price * self.daily_trackings.sum('clicks')
    end
  end

  #Using for monthly summary
  def spend_vs_budget
    spend/budget
  end

  # Enumerations
  as_enum :campaign_type, CAMPAIGN_TYPES, source: :revenue_type

  # Callback functions
  before_save do
    result = Campaign.actual_budget({
                                        price: self.unit_price.to_f,
                                        currency: unit_price_currency,
                                        campaign_type: campaign_type.to_s,
                                        target_impression: target_impression,
                                        target_click: target_click,
                                        exchange_rate: exchange_rate,
                                        discount: discount,
                                        bonus_impression: bonus_impression
                                    })

    self.unit_price_in_usd = result[:unit_price_in_usd].to_money(:USD).cents
    self.budget = result[:actual_budget].to_money(:USD).cents
  end

  after_initialize do
    sum_daily
  end

  def status
    now = Time.now.to_date
    if now < active_at.to_date
      PENDING
    elsif now > expire_at.to_date
      COMPLETED
    else
      LIVE
    end
  end

  def self.select_period_preset(period)
    period_date = get_period(period)
    select_period(period_date)
  end

  def self.select_period(value)
    joins("LEFT JOIN (SELECT SUM(views) AS views, SUM(clicks) AS clicks,campaign_id from daily_trackings WHERE (`daily_trackings`.`date` BETWEEN '#{value[0].to_formatted_s(:db)}' AND '#{value[1].to_formatted_s(:db)}') GROUP BY campaign_id ) AS s on campaigns.id = s.campaign_id").select("campaigns.*, IFNULL(s.views,0) AS views, IFNULL(s.clicks, 0) AS clicks").where.not("(active_at > ? ) OR (expire_at < ?)", value[1], value[0])
  end

  def self.get_period(period)
    case period
      when :today
        [Date.today, Date.today]
      when :yesterday
        [Date.yesterday, Date.yesterday]
      when :this_week
        [Date.today.at_beginning_of_week, Date.today.at_end_of_week]
      when :last_week
        [1.week.ago.at_beginning_of_week, 1.week.ago.at_end_of_week]
      when :this_month
        [Date.today.at_beginning_of_month, Date.today.at_end_of_month]
      when :last_month
        [1.month.ago.at_beginning_of_month, 1.month.ago.at_end_of_month]
      else
        [7.day.ago.to_date, Date.today]
    end
  end

  def self.get_expire_preiods
    {
      tomorrow: [Date.today..Date.tomorrow],
      next_3_days: [Date.today..3.days.from_now.to_date],
      next_7_days: [Date.today..7.days.from_now.to_date]
    }
  end


  def self.total_tracking(period)
    joins(:daily_trackings).select("SUM(clicks) AS clicks, SUM(views) AS views, SUM( CASE WHEN revenue_type = 1 THEN #{Campaign.table_name}.unit_price_in_usd * #{DailyTracking.table_name}.clicks ELSE #{Campaign.table_name}.unit_price_in_usd * #{DailyTracking.table_name}.views/1000 END ) as budget_spent_cents").where(DailyTracking.table_name.to_sym => {date: period[0].to_formatted_s(:db)..period[1].to_formatted_s(:db)})
  end

  def ctr
    if views.present? and views >0
      (clicks.to_f / views.to_f) * 100
    else
      0
    end
  end

  def target
    campaign_type == :CPM ? target_impression : target_click
  end

  def ecpm
    Currency.usd(views == 0 ? nil : spend / views * 1000, :USD)
  end

  def ecpc
    Currency.usd(clicks == 0 ? nil : spend / clicks, :USD)
  end

  def update_last_stats_at
    date = daily_trackings.order(date: :desc).first.try(:date)
    self.update_column(:last_stats_at, date)
  end

  def warning_health?
    health_percent > 10 || health_percent < -5
  end
end
