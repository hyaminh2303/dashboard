module Reports::Campaigns::CreativeReport
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

    query CreativeTracking, "name, SUM(impressions) as impressions, SUM(clicks) as clicks, unit_price, #{total_price_sql_col}", 'name'
  end

  def get_order_column(index)
    case index
      when 1
        'name'
      when 2
        'impressions'
      when 3
        'clicks'
      when 4
        'unit_price'
      when 5
        'total_price'
      else
        'name'
    end
  end

  def total_price_sql_col
    p %{
      IF((SELECT campaigns.revenue_type FROM campaigns WHERE campaigns.id = campaign_id) = 0, SUM(impressions) * unit_price / 1000, SUM(clicks) * unit_price) AS total_price
    }
  end
end