class ExecutiveReportsController < AuthorizationController

  def index
    @live_campaigns = Campaign.overview.live_recently.order(:name)
    @incoming_campaigns = Campaign.incoming.order(:name)
  end
end