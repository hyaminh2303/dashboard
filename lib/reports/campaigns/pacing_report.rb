module Reports::Campaigns::PacingReport
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
    campaign = Campaign.find options[:campaign_id]
    options[:campaign_type] = campaign.campaign_type
    @options = options

    # SELECT group_id,  `campaign_ads_groups`.`target` AS group_target,  `campaign_ads_groups`.`name` AS group_name,  `campaign_ads_groups`.`start_date` AS group_start_date,  `campaign_ads_groups`.`end_date` AS group_end_date, SUM( views ) AS views, SUM( clicks ) AS clicks, SUM( spend ) AS spend
    # FROM  `daily_trackings`
    # LEFT JOIN  `campaign_ads_groups` ON  `campaign_ads_groups`.`id` =  `daily_trackings`.`group_id`
    # WHERE  `daily_trackings`.`campaign_id` = campaign_id
    # GROUP BY group_id
    # ORDER BY group_name

    query DailyTracking, 'group_id, (SELECT target FROM campaign_ads_groups WHERE id = group_id) as group_target, (SELECT name FROM campaign_ads_groups WHERE id = group_id) as group_name, (SELECT start_date FROM campaign_ads_groups WHERE id = group_id) as group_start_date, (SELECT end_date FROM campaign_ads_groups WHERE id = group_id) as group_end_date, SUM(views) as views, SUM(clicks) as clicks, SUM(spend) as spend', 'group_id'
  end

  def get_order_column(index)
    case index
      when 0
        'group_name'
      when 1
        'views'
      when 2
        'clicks'
      when 3
        'ROUND((SUM(clicks)/NULLIF(SUM(views),0)),4)'
      else
        'group_id'
    end
  end
end