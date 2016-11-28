class LocationListsController < ApplicationController
  before_action :set_location_list, only: [:show, :edit, :update, :destroy]

  # GET /location_lists
  def index
    @title = I18n.translate('views.location_lists.index.title')
    @grid = LocationListsGrid.new(params[:location_lists_grid]) do |scope|
        scope.page(params[:page])
    end
  end

  # GET /location_lists/1
  def show
    @title = I18n.translate('views.location_lists.show.title')
  end

  # GET /location_lists/new
  def new
    @title = I18n.translate('views.location_lists.new.title')
    @location_list = LocationList.new
  end

  # GET /location_lists/1/edit
  def edit
    @title = I18n.translate('views.location_lists.edit.title')
  end

  # POST /location_lists
  def create
    @location_list = LocationList.new(location_list_params)
    @location_list.user = current_user
    if @location_list.save
      redirect_to @location_list, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.location_list.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /location_lists/1
  def update
    if @location_list.update(location_list_params)
      redirect_to @location_list, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.location_list.name'))
    else
      render :edit
    end
  end

  # POST /location_lists
  def expire
    @location_list = LocationList.find(params[:id])
    if @location_list.update({:status => LocationList::STATUS_EXPIRED})
      redirect_to location_lists_path, notice: I18n.t('messages.expire.success', :class_name => I18n.t('models.location_list.name'))
    end
  end

  # POST /location_lists
  def publish
    @location_list = LocationList.find(params[:id])
    if @location_list.update({:status => LocationList::STATUS_PUBLISHED})
      redirect_to location_lists_path, notice: I18n.t('messages.publish.success', :class_name => I18n.t('models.location_list.name'))
    end
  end

  # DELETE /location_lists/1
  def destroy
    @location_list.destroy
    redirect_to location_lists_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.location_list.name'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_list
      @location_list = LocationList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_list_params
      params.require(:location_list).permit(:name, :list_type, :status)
    end
end
