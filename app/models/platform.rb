class Platform < ActiveRecord::Base
  has_many :daily_trackings

  attr_accessor :opt_ext

  attr_accessor :opt_start

  attr_accessor :opt_title_row

  attr_accessor :opt_end_col
  attr_accessor :opt_end_value

  attr_accessor :opt_date_range_col
  attr_accessor :opt_date_range_row

  attr_accessor :opt_group_name_col
  attr_accessor :opt_group_name_skip_rows
  attr_accessor :opt_group_name_single_row

  attr_accessor :opt_end_group_col
  attr_accessor :opt_end_group_value

  attr_accessor :opt_attrs_date_col
  attr_accessor :opt_attrs_date_format

  attr_accessor :opt_attrs_views_col
  attr_accessor :opt_attrs_views_delimiter

  attr_accessor :opt_attrs_clicks_col
  attr_accessor :opt_attrs_clicks_delimiter

  attr_accessor :opt_attrs_spend_col

  # budget spent = campaign budget / target impressions (clicks) * accumulated impressions (clicks) in the selected dates
  # "SUM( CASE WHEN revenue_type = 1 THEN campaigns.unit_price_in_usd * daily_trackings.clicks
  #           ELSE campaigns.unit_price_in_usd * daily_trackings.views/1000 END ) as budget_spent"
  scope :stats, -> (from, to){
    select('platforms.id, platforms.name, COALESCE(SUM(views), 0) AS views,
            COALESCE(SUM(clicks),0) AS clicks,
            COALESCE(clicks * 100 / views, 0) AS ctr,
            COALESCE(SUM(spend), 0) as budget_spent')
      .joins("LEFT JOIN daily_trackings ON platforms.id = daily_trackings.platform_id
              AND date >= #{ Platform.sanitize(from.beginning_of_day) } AND date <= #{ Platform.sanitize(to.end_of_day) }")
      .group('platforms.id, platforms.name')
  }

  validates :name, :presence => true, :uniqueness => true

  def has_campaigns?
    daily_trackings.exists?
  end; alias_method :has_campaigns, :has_campaigns?

  def report_settings
    json = JSON.parse(self.options).with_indifferent_access
    json[:attributes].each do |key, value|
      value[:type] = value[:type].to_sym
    end

    if json[:end_group] and json[:end_group][:value] == ''
      json[:end_group][:value] = nil
    end

    if json[:end] and json[:end][:value] == ''
      json[:end][:value] = nil
    end

    json
  end
end
