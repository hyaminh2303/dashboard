class ClientBookingCampaignsController < ApplicationController
  layout :determine_layout
  before_action :set_campaign, only: [:show, :update, :destroy, :update_status]

  def index
    @campaigns = ClientBookingCampaign.filter_campaigns(params)
  end

  def new
  end

  def step1
  end

  def step2
  end

  def step3
  end

  def list

  end

  def show
  end

  def create
    @campaign = ClientBookingCampaign.new(campaign_params)
    @campaign.banners << update_banners
    if @campaign.save
      render json: { campaign: @campaign }
    else
      render json: { errors: @campaign.errors.full_message.join(', ') }
    end
  end

  def update
    if @campaign.update(campaign_params.merge(update_campaign_params))
      render json: { campaign: @campaign }
    else
      render json: { errors: @campaign.errors.full_message.join(', ') }
    end
  end

  def calculate_impression_assessment
    impression_assessment = ClientBookingCampaignService.calculate_impression_assessment(params)
    render json: { impression_assessment: impression_assessment }
  end

  def destroy
    @campaign.destroy
    render json: { notice: 'Destroy success' }
  end

  def update_status
    @campaign.send("#{params[:status]}!")
    render json: { notice: 'Update status success' }
  end

  def generate
    request_campaign = ClientBookingCampaign.find(params[:id])
    @campaign = CampaignService.generate(request_campaign)
    set_settings
    render 'campaigns/new', layout: 'application'
  end

  def search_locations
    @locations = Geocoder.search(params[:city])
    p '=============='
    p @locations
  end

  private
  def set_settings
    @settings = @campaign.settings
  end

  def set_campaign
    @campaign = ClientBookingCampaign.find params[:id]
  end

  def campaign_params
    params[:banners] ||= []
    params[:places] ||= []
    permited_params = params.permit(:banner_type, :no_specific_locations, :campaign_name, :advertiser_name, :description, :start_date, :end_date, :timezone, :campaign_category, :frequency_cap, :price_and_budget, :campaign_type, :ad_tag, :target, :unit_price, :budget, :country_code, :time_schedule, :carrier, :wifi_or_cellular, :os, :additional, :skip_upload_creatives, :need_yoose_help_design_creatives, :contact_email, banner_size: [], app_category: [])

    places_params = params.permit(places: [:id, :city, :_destroy, client_booking_locations_attributes: [:name, :latitude, :longitude, :radius, :_destroy, :id]])
    permited_params[:places_attributes] = places_params[:places]
    permited_params
  end

  def update_campaign_params
    permited_params = {}
    banners_params = params.permit(banners: [:id, :name, :landing_url, :client_tracking_url, :_destroy])
    permited_params[:banners_attributes] = banners_params[:banners]
    permited_params
  end

  def update_banners
    banners = []
    (params[:banners] || []).each do |b|
      banner = Banner.find(b['id'])
      banner.update(landing_url: b['landing_url'], name: b['name'])
      banners << banner
    end
    banners
  end

  def determine_layout
    action_name == 'index' ? 'clients' : false
  end
end
