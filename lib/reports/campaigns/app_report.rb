module Reports::Campaigns::AppReport
  include Reports::Campaigns::Base

  protected

  def init_report(options)
    init_campaign(options)
    @options = options
    query AppTracking, 'name, date, SUM(views) as views, SUM(clicks) as clicks', 'name'
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
