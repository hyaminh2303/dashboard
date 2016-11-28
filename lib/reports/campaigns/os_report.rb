module Reports::Campaigns::OsReport
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
    query OsTracking, 'operating_system_id, IFNULL((SELECT name FROM operating_systems WHERE id = os_trackings.operating_system_id), "Others") as name, SUM(views) as views, SUM(clicks) as clicks', 'name'
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