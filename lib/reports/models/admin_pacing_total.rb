class Reports::Models::AdminPacingTotal < Reports::Models::AdminPacing
  include Reports::Helpers::CampaignReportHelper

  def initialize(details, options)
    @views = get_total_views(details)
    @clicks = get_total_clicks(details)

    @ctr = get_ctr_by_total(details)
    # @health = get_total_group_health(details, options[:campaign_type])
    # @pacing = get_total_group_pacing(details, options[:campaign_type])
  end
end
