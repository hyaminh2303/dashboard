class CampaignsController < AuthorizationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :clear_daily_tracking, :import_io]
  before_action :set_settings, only: [ :new, :edit, :update]
  skip_authorize_resource only: [:index]

  # GET /campaigns
  def index
    @title = I18n.translate('views.campaigns.index.title')
    @grid = CampaignsGrid.new(params.fetch(:campaigns_grid, {}).merge(is_agency: current_user.is_agency?, is_campaign_manager: current_ability.can?(:create, Campaign))) do |scope|
        scope.page(params[:page]).belong_to(current_user)
    end
  end

  # GET /campaigns/1
  def show
    @title = I18n.translate('views.campaigns.show.title')
  end

  # GET /campaigns/new
  def new
    @title = I18n.translate('views.campaigns.new.title')
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
    @title = I18n.translate('views.campaigns.edit.title')
  end

  # POST /campaigns
  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user
    @campaign.settings.exchange_url = setting_params[:exchange_url]
    if @campaign.save
      redirect_to campaigns_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.campaign.name'))
    else
      set_settings
      render :new
    end
  end

  # PATCH/PUT /campaigns/1
  def update
    @campaign.settings.exchange_url = setting_params[:exchange_url]
    if @campaign.update(campaign_params)
      redirect_to campaigns_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.campaign.name'))
    else
      render :edit
    end
  end

  # DELETE /campaigns/1
  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.campaign.name'))
  end

  # DELETE /campaigns/1/clear_daily_tracking
  def clear_daily_tracking
    @campaign.daily_trackings.destroy_all
    redirect_to :back, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.daily_tracking.name'))
  end

  # POST /campaigns/1/actual_budget
  def actual_budget
    result = Campaign.actual_budget params

    respond_to do |format|
      format.json {
        render json: {
                   market_exchange_rate: result[:exchange_rate],
                   unit_price_in_usd: "$#{result[:unit_price_in_usd]}",
                   budget: result[:budget].to_money(:USD).format,
                   actual_budget: result[:actual_budget].to_money(:USD).format
               }
      }
    end
  end

  # GET /campaigns/:id/import_io
  def import_io
    @title = I18n.translate('views.campaigns.edit.title')
  end

  # PATCH /campaigns/:id/import_io
  def upload_io
    if @campaign.update(io_params)
      @campaign.update(is_attached_io: true)
      redirect_to :back, notice: I18n.t('views.campaigns.io_success_message')
    else
      redirect_to :back, alert: I18n.t('views.campaigns.io_error_message')
    end
  end

  def list
    @campaigns = Campaign.all
    respond_to do |format|
      format.json
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def set_settings
    @settings = @campaign.settings
  end

  # Only allow a trusted parameter "white list" through.
  def campaign_params
    params.require(:campaign).permit(:apply_price_creative, :name, :agency_id, :active_at, :expire_at, :target_click, :target_impression, :campaign_type, :country_code, :advertiser_name, :unit_price, :unit_price_currency, :has_location_breakdown, :has_ads_group, :target_per_ad_group, :category_id, :exchange_rate, :discount, :remark, :bonus_impression, :sales_agency_commission, :campaign_key, :development_fee, :campaign_manager)
  end

  def setting_params
    params.require(:campaign).permit(:exchange_url)
  end

  def io_params
    params.require(:campaign).permit(:signed_io)
  end
end
