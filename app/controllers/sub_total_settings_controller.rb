class SubTotalSettingsController < ApplicationController
  before_action :set_sub_total_setting, only: [:show, :edit, :update, :destroy]

  # GET /sub_total_settings
  def index
    @title = I18n.translate('views.sub_total_settings.index.title')
    @grid = SubTotalSettingsGrid.new(params[:sub_total_settings_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /sub_total_settings/1
  def show
    @title = I18n.translate('views.sub_total_settings.show.title')
  end

  # GET /sub_total_settings/new
  def new
    @title = I18n.translate('views.sub_total_settings.new.title')
    @sub_total_setting = SubTotalSetting.new
  end

  # GET /sub_total_settings/1/edit
  def edit
    @title = I18n.translate('views.sub_total_settings.edit.title')
  end

  # POST /sub_total_settings
  def create
    @sub_total_setting = SubTotalSetting.new(sub_total_setting_params)
    if @sub_total_setting.save
      redirect_to sub_total_settings_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.sub_total_setting.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /sub_total_settings/1
  def update
    if @sub_total_setting.update(sub_total_setting_params)
      redirect_to sub_total_settings_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.sub_total_setting.name'))
    else
      render :edit
    end
  end

  # DELETE /sub_total_settings/1
  def destroy
    @sub_total_setting.destroy
    redirect_to sub_total_settings_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.sub_total_setting.name'))
  end

  def list
    @sub_total_settings = SubTotalSetting.all
    render json: { sub_total_settings: @sub_total_settings }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_total_setting
      @sub_total_setting = SubTotalSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sub_total_setting_params
      params.require(:sub_total_setting).permit(:name, :value, :sub_total_setting_type)
    end
end
