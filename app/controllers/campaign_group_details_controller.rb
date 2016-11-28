class CampaignGroupDetailsController < ApplicationController
  include CampaignDetailsHelper

  before_action :set_campaign
  before_action :check_has_ads_group
  before_action :set_group
  before_action :check_agency

  # GET /campaign_details/1
  def index
    @title = I18n.translate('views.campaign_details.group_details.title')

    if can? :manage, Campaign
      _class = Reports::CampaignBy::AdminDailyReport
      _location_class = Reports::CampaignBy::AdminLocationReport
      _os_class = Reports::CampaignBy::AdminOsReport
      _creative_class = Reports::CampaignBy::AdminCreativeReport
      _device_class = Reports::CampaignBy::AdminDeviceReport
      _app_class = Reports::CampaignBy::AdminAppReport
    else
      _class = Reports::CampaignBy::AgencyDailyReport
      _location_class = Reports::CampaignBy::AgencyLocationReport
      _os_class = Reports::CampaignBy::AgencyOsReport
      _creative_class = Reports::CampaignBy::AgencyCreativeReport
      _device_class = Reports::CampaignBy::AgencyDeviceReport
      _app_class = Reports::CampaignBy::AdminAppReport
    end

    if params[:format] == 'json'
      @report = _class.new params
    else
      @report = _class.new params.merge(skip_details: true)
      if !@campaign.has_ads_group?
        if @campaign.has_location_breakdown?
          @location_report = _location_class.new params.merge(skip_details: true)
        end
        @device_report = _device_class.new params
        @os_report = _os_class.new params
        @creative_report = _creative_class.new params
        @device_report = _device_class.new params
        @app_report = _app_class.new params
      end
    end
  end

  private
  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_group
    @group = CampaignAdsGroup.find(params[:group_id]) if @campaign.has_ads_group?
  end

  def check_has_ads_group
    if params[:format] == 'json'
      return
    end

    # current path is campaign detail and has ads group
    if request.path == index_campaign_details_path(params[:campaign_id]) and
        @campaign.has_ads_group?
      redirect_to index_campaign_group_stats_path(@campaign)
    end

    # current path is campaign group detail and has NO ads group
    unless params[:group_id].nil?
      if request.path == detail_campaign_group_stats_path(params[:campaign_id], params[:group_id]) and
          !@campaign.has_ads_group?
        redirect_to index_campaign_details_path(@campaign)
      end
    end
  end
end
