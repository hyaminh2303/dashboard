class CampaignGroupStatsController < ApplicationController
  include CampaignDetailsHelper

  before_action :set_campaign
  before_action :check_agency
  before_action :check_has_ads_group, except: [:notify]

  layout false, only: [:notify]

  def index
    @title = I18n.translate('views.campaign_details.group_stats.title')

    if can? :manage, Campaign
      _class = Reports::CampaignBy::AdminGroupReport
      _pacing = Reports::CampaignBy::AdminPacingReport
      _os_class = Reports::CampaignBy::AdminOsReport
      _app_class = Reports::CampaignBy::AdminAppReport
      _device_class = Reports::CampaignBy::AdminDeviceReport
      _location_class = Reports::CampaignBy::AdminLocationReport
      _creative_class = Reports::CampaignBy::AdminCreativeReport
    else
      _class = Reports::CampaignBy::AgencyGroupReport
      _pacing = Reports::CampaignBy::AdminPacingReport
      _os_class = Reports::CampaignBy::AgencyOsReport
      _app_class = Reports::CampaignBy::AdminAppReport
      _device_class = Reports::CampaignBy::AgencyDeviceReport
      _location_class = Reports::CampaignBy::AgencyLocationReport
      _creative_class = Reports::CampaignBy::AgencyCreativeReport
    end

    if params[:format] == 'json'
      @report = _class.new params
      @os_report = _os_class.new params
      @app_report = _app_class.new params
      @device_report = _device_class.new params
      @pacing_report = _pacing.new params if show_pacing_data
      @creative_report = _creative_class.new params
    else
      @report = _class.new params.merge(skip_details: true)
      @os_report = _os_class.new params
      @app_report = _app_class.new params
      @device_report = _device_class.new params
      @pacing_report = _pacing.new params if show_pacing_data
      @creative_report = _creative_class.new params
      @location_report = _location_class.new params.merge(skip_details: true)
    end
  end

  def notify
    AgencyMailer.ready_for_finance_email(@campaign).deliver
    @campaign.update_attributes(is_notified: true, user_notify_id: current_user.id)
    redirect_to index_campaign_group_stats_path(@campaign)
  end

  private

  def show_pacing_data
    @campaign.target_per_ad_group && ( current_user.admin? || current_user.super_admin?)
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def check_has_ads_group
    if params[:format] == 'json'
      return
    end
    unless @campaign.has_ads_group?
      redirect_to index_campaign_details_path(@campaign)
    end
  end
end
