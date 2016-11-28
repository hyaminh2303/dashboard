class CampaignPacingStatsController < ApplicationController
  include CampaignDetailsHelper

  before_action :set_campaign
  before_action :check_agency

  def index
    _class = Reports::CampaignBy::AdminPacingReport

    if params[:format] == 'json'
      @report = _class.new params
    end
  end

  private
  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
