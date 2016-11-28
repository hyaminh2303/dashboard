class CampaignAdsGroupsController < AuthorizationController
  before_action :set_campaign, only: [:index, :edit]
  before_action :check_has_ads_group, only: [:index, :edit] # only from above
  before_action :set_campaign_ads_group, only: [:show, :edit, :update, :destroy]

  # GET /campaign_ads_groups
  def index
    @title = I18n.translate('views.campaign_ads_groups.index.title')
    @campaign_ads_group = CampaignAdsGroup.new
    set_grid
  end

  # GET /campaign_ads_groups/1
  def show
    @title = I18n.translate('views.campaign_ads_groups.show.title')
  end

  # GET /campaign_ads_groups/new
  def new
    @title = I18n.translate('views.campaign_ads_groups.new.title')
    @campaign_ads_group = CampaignAdsGroup.new
  end

  # GET /campaign_ads_groups/1/edit
  def edit
    @title = I18n.translate('views.campaign_ads_groups.edit.title')
  end

  # POST /campaign_ads_groups
  def create
    @campaign_ads_group = CampaignAdsGroup.new(campaign_ads_group_params)
    @campaign_ads_group.campaign_id = params[:campaign_id]
    if @campaign_ads_group.save
      redirect_to({ action: 'index'}, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.campaign_ads_group.name')))
    else
      set_campaign
      set_grid
      @title = I18n.translate('views.campaign_ads_groups.index.title')
      render :index
    end
  end

  # PATCH/PUT /campaign_ads_groups/1
  def update
    if @campaign_ads_group.update(campaign_ads_group_params)
      redirect_to({ action: 'index'}, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.campaign_ads_group.name')))
    else
      set_campaign
      render :edit
    end
  end

  # DELETE /campaign_ads_groups/1
  def destroy
    # unless check_daily_tracking_association @campaign_ads_group.id, I18n.t('views.campaign_ads_groups.destroy.unable', group_name: @campaign_ads_group.name)
    @campaign_ads_group.destroy
    redirect_to campaign_ads_group_index_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.campaign_ads_group.name'))
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def check_has_ads_group
    unless @campaign.has_ads_group?
      redirect_to campaigns_path
    end
  end

  def set_campaign_ads_group
    @campaign_ads_group = CampaignAdsGroup.find(params[:id])
  end

  def set_grid
    grid_ads = @campaign.target_per_ad_group ? CampaignAdsGroupsTargetGrid : CampaignAdsGroupsGrid
    
    @grid = grid_ads.new(params[:campaign_ads_groups_grid]) do
      @campaign.campaign_ads_groups.page(params[:page])
    end
  end

  # def check_daily_tracking_association(group_id, redirect_msg)
  #   if DailyTracking.where(group_id: group_id).count > 0
  #     redirect_to campaign_ads_group_index_url, alert: redirect_msg
  #     return true
  #   end
  #   false
  # end

  # Only allow a trusted parameter "white list" through.
  def campaign_ads_group_params
    params.require(:campaign_ads_group).permit(:name, :keyword, :description, :target, :start_date, :end_date)
  end
end
