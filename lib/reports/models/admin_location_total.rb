class Reports::Models::AdminLocationTotal < Reports::Models::AdminLocation
  include Reports::Helpers::CampaignReportHelper

  def initialize(details)
    @views = get_total_views(details)
    @clicks = get_total_clicks(details)

    @ctr = get_ctr_by_total(details)
  end
end
