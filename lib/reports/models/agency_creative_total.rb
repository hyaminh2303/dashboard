class Reports::Models::AgencyCreativeTotal < Reports::Models::AgencyCreative
  include Reports::Helpers::CampaignReportHelper

  def initialize(details, campaign)
    @impressions = get_total_impressions(details)
    @clicks = get_total_clicks(details)
    @ctr = get_ctr_by_total_impressions(details)
    @spend = get_total_spend(details, campaign)
    @unit_price = 0
    @total_price = get_total_price(details).round(2)
  end
end
