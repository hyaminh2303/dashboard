class Reports::Models::AdminCampaign
  include Reports::Models::TrackingRecord
  include Reports::Helpers::CampaignReportHelper

  attr_accessor :data
  attr_reader :platform

  def initialize(detail, targeted = false, campaign_type = {}, options = {})
    init_detail(detail)
    @spend = Currency.usd(detail.spend, :USD)
    @ecpm = get_ecpm(detail)
    @ecpc = get_ecpc(detail)
    type(detail, options)
    if targeted && detail.group_target.present? && detail.group_start_date.present? && detail.group_end_date.present?
      @group_health = get_group_health(detail, campaign_type)
      @group_pacing = get_group_pacing(detail, campaign_type).round(0)
    else
      @group_health = 0
      @group_pacing = 0
    end
  end

  def group_health_in_percent(health)
    (health * 100).round(2).to_s + '%'
  end

  def get_group_health(detail, campaign_type)
    health = delivery_realized(detail, campaign_type) - delivery_expected(detail)
    group_health_in_percent(health)
  end

  def delivery_realized(detail, campaign_type)
    value = campaign_type == :CPM ? detail.views : detail.clicks
    detail.group_target == 0 ? 0.0 : value.to_f / detail.group_target.to_f
  end

  def get_group_pacing(detail, campaign_type)
    if Time.now.to_date < detail.group_start_date.to_date
      # Future campaign
      days = (detail.group_end_date.to_date - detail.group_start_date.to_date + 1).to_i
    elsif Time.now.to_date > detail.group_end_date.to_date
      # Past campaign
      return 0
    else
      days = (detail.group_end_date.to_date - Time.now.to_date + 1).to_i
    end

    remaining = detail.group_target - (campaign_type == :CPM ? detail.views : detail.clicks)
    days == 0 ? remaining.to_f / 1 : remaining.to_f / days.to_f
  end

  def delivery_expected(detail)
    if detail.group_target == 0
      return 0.0
    end

    if Time.now.to_date > detail.group_end_date.to_date
      return 1.0
    elsif Time.now.to_date < detail.group_start_date.to_date
      return 0.0
    end

    _target = detail.group_target.to_f
    number_of_day = (detail.group_end_date.to_date - detail.group_start_date.to_date + 1).to_i.to_f
    days_left = (detail.group_end_date.to_date - Time.now.to_date + 1).to_i.to_f

    ((_target / number_of_day) * (number_of_day - days_left)) / _target
  end

  def ecpm
    @ecpm.nil? ? nil : @ecpm.amount
  end

  def ecpm_formatted
    @ecpm.nil? ? I18n.t('statuses.not_available') : @ecpm.format
  end

  def ecpc
    @ecpc.nil? ? nil : @ecpc.amount
  end

  def ecpc_formatted
    @ecpc.nil? ? I18n.t('statuses.not_available') : @ecpc.format
  end

  def hash
    _hash = hash_detail.merge({
                      ecpm: ecpm_formatted,
                      ecpc: ecpc_formatted
                  })

    unless platform.nil?
      _hash[:platform] = platform
    end

    unless data.nil?
      _hash[:data] = data.map do |d|
        d.hash
      end
    end

    _hash
  end

  private
  def type(detail, options)
    @options = options

    case options[:type]
    when :sub
      @platform = detail.platform.name
    end
  end
end
