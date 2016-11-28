class PlatformsController < AuthorizationController
  include PlatformsHelper

  before_action :set_platform, only: [:show, :edit, :update, :destroy]

  # GET /platforms
  def index
    # @title = I18n.translate('views.platforms.index.title')
    # @grid = PlatformsGrid.new(params[:platforms_grid]) do |scope|
    #     scope.page(params[:page])
    # end
    respond_to do |format|
      format.html
      format.json {
        start_date = Time.zone.parse(params[:from])
        end_date = Time.zone.parse(params[:to])
        start = params[:start].to_i
        limit = params[:limit].to_i

        @platforms = Platform.stats(start_date, end_date)
        @platforms = @platforms.order("#{params[:sort_by]} #{params[:sort_dir]}") if params[:sort_by].present?
        @platforms = @platforms.offset(start).limit(limit)

        @daily_tracking_stats = DailyTracking.stats(start_date, end_date).first
      }
    end
  end

  def stats
    start_date = Time.zone.parse(params[:from])
    end_date = Time.zone.parse(params[:to])

    @stats = DailyTracking.stats(start_date, end_date, true)
    @stats = @stats.where(platform_id: params[:platform_id]) if params[:platform_id]

    @stats = @stats.map do |data|
      [data.date.to_time.to_i * 1000,  data[params[:field]]]
    end

    render json: @stats
  end

  # GET /platforms/1
  def show
    @title = I18n.translate('views.platforms.show.title')
  end

  # GET /platforms/new
  def new
    @title = I18n.translate('views.platforms.new.title')
    @platform = Platform.new
  end

  # GET /platforms/1/edit
  def edit
    @title = I18n.translate('views.platforms.edit.title')
  end

  # POST /platforms
  def create
    @platform = Platform.new(platform_params)

    #Get option_params & build to JSON
    @platform.options = option_builder option_params

    if @platform.save
      redirect_to platforms_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.platform.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /platforms/1
  def update
    #Get option_params & build to JSON
    @platform.options = option_builder option_params

    if @platform.update(platform_params)
      redirect_to platforms_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.platform.name'))
    else
      render :edit
    end
  end

  # DELETE /platforms/1
  def destroy
    if @platform.has_campaigns?
      redirect_to platforms_url, alert: I18n.t('messages.destroy.fail.dependent', :class_name => I18n.t('models.platform.name').downcase)
    else
      @platform.destroy
      render json: {}
      #redirect_to platforms_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.platform.name'))
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_platform
    @platform = Platform.find(params[:id])

    unless @platform.options.nil? or @platform.options.empty?
      json = JSON.parse @platform.options

      @platform.opt_ext = json['ext']
      @platform.opt_start = json['start']
      @platform.opt_title_row = json['title_row'].nil? ? '' :json['title_row']

      @platform.opt_date_range_col = json['date_range'].nil? ? '' : json['date_range']['col']
      @platform.opt_date_range_row = json['date_range'].nil? ? '' : json['date_range']['row']

      @platform.opt_end_col = json['end'].nil? ? '' : json['end']['col']
      @platform.opt_end_value = json['end'].nil? ? '' : json['end']['value']

      @platform.opt_group_name_col = json['group_name']['col']
      @platform.opt_group_name_skip_rows = json['group_name']['skip_rows']
      @platform.opt_group_name_single_row = json['group_name']['single_row'] == '0' || json['group_name']['single_row'].nil? ? false : true

      @platform.opt_end_group_col = json['end_group'].nil? ? '' : json['end_group']['col']
      @platform.opt_end_group_value = json['end_group'].nil? ? '' : json['end_group']['value']

      @platform.opt_attrs_date_col = json['attributes']['date']['col']
      @platform.opt_attrs_date_format = json['attributes']['date']['options']['format']

      @platform.opt_attrs_views_col = json['attributes']['views']['col']
      options = json['attributes']['views']['options']
      @platform.opt_attrs_views_delimiter = options.nil? ? '' : options['delimiter']

      @platform.opt_attrs_clicks_col = json['attributes']['clicks']['col']
      options = json['attributes']['clicks']['options']
      @platform.opt_attrs_clicks_delimiter = options.nil? ? '' : options['delimiter']

      @platform.opt_attrs_spend_col = json['attributes']['spend']['col']
    end
  end

  # Only allow a trusted parameter "white list" through.
  def platform_params
    params.require(:platform).permit(:name)
  end

  def option_params
    params.require(:platform).permit(:opt_ext, :opt_start, :opt_end_col, :opt_end_value,
                                     :opt_title_row, :opt_date_range_col, :opt_date_range_row,
                                     :opt_group_name_col, :opt_group_name_skip_rows,
                                     :opt_group_name_single_row, :opt_end_group_col, :opt_end_group_value,
                                     :opt_attrs_date_col, :opt_attrs_date_format, :opt_attrs_views_col,
                                     :opt_attrs_views_delimiter, :opt_attrs_clicks_col,
                                     :opt_attrs_clicks_delimiter, :opt_attrs_spend_col)
  end
end
