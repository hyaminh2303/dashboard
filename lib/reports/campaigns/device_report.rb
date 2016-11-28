module Reports::Campaigns::DeviceReport
  include Reports::Campaigns::Base

  protected
  # ==== Parameters
  # * +options+ - Options for query report:
  #   :campaign_id =>
  #   :group_id =>
  #   :start => Index of start record, for by datatable
  #   :length => Length per page by datatable
  #   :order[0]{ :column, :dir} => Order column index & dir (asc, desc)
  def init_report(options)
    init_campaign(options)
    @options = options

    # specify whether ad group column is visible. If there is no campaign_ads_group_id then definitely no need to show such column
    if DeviceTracking.where('campaign_ads_group_id IS NOT NULL AND campaign_id = ' + @campaign.id.to_s).first.nil?
      @ads_group_hidden = true
    else
      @ads_group_hidden = false
    end
    if @ads_group_hidden == false
      query DeviceTracking, 'date_range, campaign_ads_group_id, (SELECT name FROM campaign_ads_groups WHERE id = device_trackings.campaign_ads_group_id) as name, SUM(clicks) as clicks, SUM(views) as views, SUM(number_of_device_ids) as number_of_device_ids, SUM(frequency_cap) as frequency_cap', 'id'
    else
      query DeviceTracking, 'date_range, campaign_ads_group_id, "no group" as name, SUM(clicks) as clicks, SUM(views) as views, SUM(number_of_device_ids) as number_of_device_ids, SUM(frequency_cap) as frequency_cap', 'id'
    end

  end

  def get_order_column(index)
    case index
      when 1
        'id'
      when 2
        'name'
      when 3
        'clicks'
      else
        'id'
    end
  end
end