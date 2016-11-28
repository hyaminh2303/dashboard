class LocationsController < AuthorizationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  def index
    keyword = '---'
    keyword = params[:locations_grid]['name'] if !params[:locations_grid].nil?
    @title = I18n.translate('views.locations.index.title')
    @grid = LocationsGrid.new(params[:locations_grid]) do |scope|
      scope.search(keyword, current_user).page(params[:page])
    end
    @l_total_rows = LocationTracking.search(keyword, current_user).length
  end

  # GET /locations/1
  def show
    @title = I18n.translate('views.locations.show.title')
  end

  # GET /locations/new
  def new
    @title = I18n.translate('views.locations.new.title')
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    @title = I18n.translate('views.locations.edit.title')
  end

  # POST /locations
  def create
    @location = Location.new(location_params)
    @location.user = current_user
    if @location.save
      redirect_to @location, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.location.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.location.name'))
    else
      render :edit
    end
  end

  # POST /locations
  def expire
    @location = Location.find(params[:id])
    if @location.update({:status => Location::STATUS_EXPIRED})
      redirect_to locations_path, notice: I18n.t('messages.expire.success', :class_name => I18n.t('models.location.name'))
    end
  end

  # POST /locations
  def publish
    @location = Location.find(params[:id])
    if @location.update({:status => Location::STATUS_PUBLISHED})
      redirect_to locations_path, notice: I18n.t('messages.publish.success', :class_name => I18n.t('models.location.name'))
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    redirect_to locations_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.location.name'))
  end

  # GET /locations/import
  def import
    if request.post?
      require 'csv'
      uploader = LocationUploader.new
      uploader.store!(import_locations_params[:file])

      # Process CSV
      locations = []
      CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true) do |row|
        location = Location.new(row.to_hash)
        location.user = current_user
        locations << location
      end
      result = Location.import locations, validate: true
      redirect_to locations_path, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.location.name'))
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def location_params
    params.require(:location).permit(:name, :address, :zip_code, :country_code, :longitude, :latitude, :status, {location_list_ids: []})
  end

  def import_locations_params
    params.require(:locations).permit(:file)
  end
end
