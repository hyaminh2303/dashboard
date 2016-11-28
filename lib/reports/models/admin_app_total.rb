class Reports::Models::AdminCreativeTotal < Reports::Models::AdminCreative
  include Reports::Helpers::CampaignReportHelper

  def initialize(details)
    @views = get_total_impressions(details)
    @clicks = get_total_clicks(details)
    @ctr = get_ctr_by_total_impressions(details)
  end
end
