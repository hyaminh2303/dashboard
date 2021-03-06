module Reports::Campaigns::LocationReport
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
    query LocationTracking, 'location_id, name, (SELECT name FROM locations WHERE id = location_trackings.location_id) as location_name, SUM(views) as views, SUM(clicks) as clicks', 'name'
  end

  def get_order_column(index)
    case index
      when 1
        'name'
      when 2
        'views'
      when 3
        'clicks'
      else
        'name'
    end
  end
end
