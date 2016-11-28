class DailyTrackingsController < AuthorizationController
  include ApplicationHelper
  include DailyTrackingsHelper

  before_action :set_daily_tracking, only: [:show, :edit, :update, :destroy]
  before_action :set_campaign, only: [:new, :edit, :create, :update, :import, :import_post]
  before_action :set_date, only: [:new, :edit, :create, :update]
  skip_authorize_resource only: [:views, :clicks, :budget_spent]

  # GET /daily_trackings
  def index
    @title = I18n.translate('views.daily_trackings.index.title')
    redirect_to new_campaign_daily_tracking_path
  end

  # POST /daily_trackings/list.json
  def views
    stats = BaseStats.get_type(:views, current_user, params)
    daily_trackings = stats.views
    render json: {category: daily_trackings.keys, data: daily_trackings.values}
  end

  def clicks
    stats = BaseStats.get_type(:clicks, current_user, params)
    daily_trackings = stats.clicks
    render json: {category: daily_trackings.keys, data: daily_trackings.values}
  end

  def budget_spent
    stats = BaseStats.get_type(:budget_spent, current_user, params)
    daily_trackings = stats.budget_spent
    render json: {category: daily_trackings.keys, data: daily_trackings.values}
  end

  # GET /daily_trackings/1
  def show
    @title = I18n.translate('views.daily_trackings.show.title')
  end

  # GET /daily_trackings/new
  def new
    @title = I18n.translate('views.daily_trackings.new.title')
    @daily_tracking = DailyTracking.new
    @daily_tracking.date = @date

    set_grid @date
  end

  # GET /daily_trackings/1/edit
  def edit
    @title = I18n.translate('views.daily_trackings.edit.title')
  end

  # POST /daily_trackings
  def create
    @daily_tracking = DailyTracking.new(daily_tracking_params)
    @daily_tracking.campaign_id = params[:campaign_id]
    @daily_tracking.date = @date
    if @daily_tracking.save
      # Redirect back to new page
      redirect_to_new @daily_tracking.date, I18n.t('messages.create.success', :class_name => I18n.t('models.daily_tracking.name'))
      @campaign.update_last_stats_at
    else
      set_grid @daily_tracking.date

      # Redirect back to new page
      @title = I18n.translate('views.daily_trackings.new.title')
      render :new
    end
  end

  # PATCH/PUT /daily_trackings/1
  def update
    if @daily_tracking.update(daily_tracking_params)
      redirect_to_new @daily_tracking.date, I18n.t('messages.update.success', :class_name => I18n.t('models.daily_tracking.name'))
    else
      @title = I18n.translate('views.daily_trackings.edit.title')
      render :edit
    end
  end

  # DELETE /daily_trackings/1
  def destroy
    @daily_tracking.destroy

    # Redirect back to new page
    redirect_to_new @daily_tracking.date, I18n.t('messages.destroy.success', :class_name => I18n.t('models.daily_tracking.name'))
  end

  # GET /daily_trackings/import
  def import
    @title = I18n.translate('views.daily_trackings.import.title')
  end

  # POST /daily_trackings/import
  def import_post
    platform = Platform.find(import_params[:platform_id])
    groups = @campaign.campaign_ads_groups.map { |g| [g.id, g.keyword.strip] }

    begin
      if import_sum? and import_params[:file].length > 1
        result = import_for_sum platform, groups
      else
        result = import_for_normal platform, groups
      end

      Rails.logger.warn result[:unprocessed_groups]
      Rails.logger.warn result[:skips]
      Rails.logger.warn result[:errors]

      @notice = I18n.t('views.daily_trackings.import.result', unprocessed_groups: result[:unprocessed_groups][:count], success: result[:success], skip: result[:skips].count, failure: result[:errors].count)

      unprocessed_groups = result[:unprocessed_groups][:groups]
      @error_details = unprocessed_groups.length > 0 ? [I18n.t('views.daily_trackings.import.unprocessed_groups_message', unprocessed_groups: unprocessed_groups.join(', '))] : []
      @error_details.concat(get_skip_messages(result[:skips])).concat(result[:errors_messages])
      @campaign.update_last_stats_at
    rescue Exception => e
      @error_messages = [ I18n.t('views.daily_trackings.import.exception', message: e.message)]
    end

    render 'import'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_daily_tracking
    @daily_tracking = DailyTracking.find(params[:id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_date
    if params[:date].nil?
      @date = Date.yesterday
    else
      @date = Date.parse params[:date]
    end

    # Reset date if it out of range
    if @date < @campaign.active_at
      @date = @campaign.active_at
    end
    if @date > @campaign.expire_at
      @date = @campaign.expire_at
    end
  end

  # Get daily_trackings by campaign & date and set to Grid
  def set_grid date
    @grid = DailyTrackingsGrid.new(params.fetch(:daily_trackings_grid, {}).merge(has_ads_group: @campaign.has_ads_group?)) do
      @campaign.daily_trackings.where(:date => date).page(params[:page])
    end
  end

  def redirect_to_new(date, notice)
    redirect_to({action: 'new', date: date_to_iso_string(date)}, notice: notice)
  end

  def get_unprocessed_groups_data(unprocessed_groups)
    count = unprocessed_groups.count { |o| !o.nil?}
    total_record = unprocessed_groups.sum { |o| o.records.length}
    groups = unprocessed_groups.map { |o| o.name}

    { :count => count, :groups => groups, :total_record => total_record}
  end

  def get_skip_messages(skips)
    skips.map do |s|
      I18n.t('views.daily_trackings.import.skip_message', date: s.date.strftime(Date::DATE_FORMATS[:iso]))
    end
  end

  def get_errors_messages(db_record)
    I18n.t('views.daily_trackings.import.errors_message', date: db_record.date.strftime(Date::DATE_FORMATS[:iso]), errors: db_record.errors.full_messages[0])
  end

  # Only allow a trusted parameter "white list" through.
  def daily_tracking_params
    params.require(:daily_tracking).permit(:campaign_id, :platform_id, :group_id, :date, :views, :clicks, :spend)
  end

  def import_params
    params.require(:daily_tracking).permit(:platform_id, :platform, :override, :sum, :file => [])
  end

  def import_override?
    import_params[:override] == "1" ? true : false
  end

  def import_sum?
    import_params[:sum] == "1" ? true : false
  end
end
