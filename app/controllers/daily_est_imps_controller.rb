class DailyEstImpsController < AuthorizationController
  before_action :set_daily_est_imp, only: [:show, :edit, :update, :destroy]

  # GET /daily_est_imps
  def index
    @title = I18n.t('views.daily_est_imps.index.title')
    @grid = DailyEstImpsGrid.new(params[:daily_est_imps_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /daily_est_imps/1
  def show
    @title = I18n.translate('views.daily_est_imps.show.title')
  end

  # GET /daily_est_imps/new
  def new
    @title = I18n.translate('views.daily_est_imps.new.title')
    @daily_est_imp = DailyEstImp.new
  end

  # GET /daily_est_imps/1/edit
  def edit
    @title = I18n.translate('views.daily_est_imps.edit.title')
  end

  # POST /daily_est_imps
  def create
    @daily_est_imp = DailyEstImp.new(daily_est_imp_params)
    if @daily_est_imp.save
      redirect_to daily_est_imps_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.daily_est_imp.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /daily_est_imps/1
  def update
    if @daily_est_imp.update(daily_est_imp_params)
      redirect_to daily_est_imps_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.daily_est_imp.name'))
    else
      render :edit
    end
  end

  # DELETE /daily_est_imps/1
  def destroy
    # Do not allow destroy daily_est_imp if is Agency. this case will not happend because destroy button is already hide
    @daily_est_imp.destroy

    redirect_to daily_est_imps_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.daily_est_imp.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_est_imp
      @daily_est_imp = DailyEstImp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def daily_est_imp_params
      return {} if params[:daily_est_imp][:banner_size_id].blank?
      return {} if params[:daily_est_imp][:country_code].blank?

      params[:daily_est_imp][:banner_size] = BannerSize.find_by(params[:daily_est_imp][:banner_size_id]).size
      params[:daily_est_imp][:country_name] = Country[params[:daily_est_imp][:country_code]].name

      params.require(:daily_est_imp).permit(:country_code, :country_name, :impression, :banner_size)
    end
end
