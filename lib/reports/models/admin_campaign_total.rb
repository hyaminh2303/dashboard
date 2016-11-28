class Reports::Models::AdminCampaignTotal < Reports::Models::AdminCampaign
  include Reports::Helpers::CampaignReportHelper

  def initialize(details)
    @views = get_total_views(details)
    @clicks = get_total_clicks(details)

    @ctr = get_ctr_by_total(details)

    @spend = Currency.usd(get_total_actual_spend(details), :USD)
    @ecpm = get_ecpm_by_total_actual_spend(details)
    @ecpc = get_ecpc_by_total_actual_spend(details)
  end
end
