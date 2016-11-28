class Reports::Models::AdminCreativeTotal < Reports::Models::AdminCreative
  include Reports::Helpers::CampaignReportHelper

  def initialize(details)
    @impressions = get_total_impressions(details)
    @clicks = get_total_clicks(details)
    @ctr = get_ctr_by_total_impressions(details)
    @unit_price = 0
    @total_price = get_total_price(details).round(2)
  end
end
