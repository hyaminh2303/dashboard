require 'charlock_holmes'

class LocationTrackingsController < AuthorizationController
  include ApplicationHelper

  before_action :set_campaign,            only: [:index, :new, :edit, :create, :update, :import, :destroy]

  # Check for allow location breakdown
  before_action :check_location_breakdown, except: [:heat]

  before_action :set_date,                only: [:index, :new, :create, :edit, :update, :import, :destroy]

  before_action :set_location_tracking,   only: [:show, :edit, :update, :destroy]
  before_action :init_error_messages,     only: :import
  skip_authorize_resource only: [:heat]


  # GET /location_trackings
  def index
    @title = I18n.translate('views.location_trackings.index.title')
    trackings = @campaign.location_trackings
    @number_of_trackings = trackings.length
    @grid = LocationTrackingsGrid.new(params[:location_trackings_grid]) do
      trackings.page(params[:page]).per(10)
    end

    @row = params[:page].nil? ? 0 : (params[:page].to_i - 1) * 10
  end

  # GET /location_trackings/1
  def show
    @title = I18n.translate('views.location_trackings.show.title')
  end

  # GET /location_trackings/new
  def new
    @title = I18n.translate('views.location_trackings.new.title')
    @location_tracking = LocationTracking.new
  end

  # GET /location_trackings/1/edit
  def edit
    @title = I18n.translate('views.location_trackings.edit.title')
  end

  # GET /location_tracking/heat
  def heat
    is_campaign = params[:campaign_id].to_i > 0
    params[:user] = current_user

    if is_campaign
      location_heat = CampaignLocationHeat.new(params)
    else
      location_heat = TotalLocationHeat.new(params)
    end

    render json: location_heat.data
  end

  # GET /location_trackings/import
  def import
    @title = I18n.translate('views.location_trackings.import.title')

    if request.post?
      require 'csv'
      uploader = LocationTrackingUploader.new
      uploader.store!(import_location_trackings_params[:file])

      # Get file encoding
      encoding = get_file_encoding "#{Rails.public_path}#{uploader.url}"

      # Process location first
      unless import_locations uploader, encoding
        redirect_to_index_with_alert @error_lines
        return
      end

      # Destroy all imported data
      LocationTracking.where(campaign_id: @campaign.id).destroy_all

      # Process CSV
      unless import_trackings uploader, encoding
        redirect_to_index_with_alert @error_lines
        return
      end

      redirect_to_index I18n.t('messages.create.success', :class_name => I18n.t('models.location_tracking.name'))
    end
  end

  # POST /location_trackings
  def create
    @location_tracking = LocationTracking.new(location_tracking_params)
    @location_tracking.campaign_id = @campaign.id
    @location_tracking.date = @date
    if @location_tracking.save
      redirect_to_index I18n.t('messages.create.success', :class_name => I18n.t('models.location_tracking.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /location_trackings/1
  def update
    if @location_tracking.update(location_tracking_params)
      redirect_to_index I18n.t('messages.update.success', :class_name => I18n.t('models.location_tracking.name'))
    else
      render :edit
    end
  end

  # DELETE /location_trackings/1
  def destroy
    @location_tracking.destroy
    redirect_to_index I18n.t('messages.destroy.success', :class_name => I18n.t('models.location_tracking.name'))
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location_tracking
    @location_tracking = LocationTracking.find(params[:id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def check_location_breakdown
    # If campaign does not allow location breakdown, redirect to home
    unless @campaign.has_location_breakdown?
      redirect_to root_path
    end
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

  def redirect_to_index(notice)
    redirect_to({action: 'index'}, notice: notice)
  end

  def redirect_to_index_with_alert(lines_array)
    redirect_to({action: 'index'}, alert: I18n.t('models.location_tracking.validate.error_on_lines', lines: lines_array.join(', ')))
  end

  # Init global var @error_messages for view can show error (if any)
  def init_error_messages
    @error_messages = []
    @error_lines = []
  end

  def import_locations(uploader, encode = 'UTF-8')
    result = true
    locations = []
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and !(row['name'].nil? and row['latitude'].nil? and row['longitude'].nil? and row['views'].nil? and row['clicks'].nil?)
        location = Location.where(latitude: row['latitude'], longitude: row['longitude']).first

        if location.nil?
          location = Location.new name: row['name'],
                                  latitude: row['latitude'],
                                  longitude: row['longitude'],
                                  user: current_user

          if set_error_messages location, current_line
            # Some errors has been set
            result = false
          else
            # everything are valid
            locations << location
          end
        end
      end

      current_line += 1
    end

    if result
      Location.import locations
    end

    result
  end

  def import_trackings(uploader, encode = 'UTF-8')
    result = true
    trackings = []
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and !(row['name'].nil? and row['latitude'].nil? and row['longitude'].nil? and row['views'].nil? and row['clicks'].nil?)
        tracking = LocationTracking.new name: row['name'],
                                        campaign_id: params[:campaign_id],
                                        location_id: Location.where(latitude: row['latitude'], longitude: row['longitude']).first.id,
                                        date: @date,
                                        views: row['views'],
                                        clicks: row['clicks']

        if set_error_messages tracking, current_line
          # Some errors has been set
          result = false
        else
          # everything are valid
          trackings << tracking
        end
      end

      current_line += 1
    end

    if result
      LocationTracking.import trackings
    end

    result
  end

  def set_error_messages(model, csv_line)
    if model.valid?
      return false
    end

    Rails.logger.error model.errors.full_messages

    model.errors.full_messages.each do |msg|
      @error_messages << "Line #{csv_line}: #{msg}"

      unless @error_lines.include? csv_line
        @error_lines << csv_line
      end
    end

    true
  end

  def get_file_encoding(path)
    CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]
  end

  # Only allow a trusted parameter "white list" through.
  def location_tracking_params
    params.require(:location_tracking).permit(:name, :campaign_id, :date, :location_id, :views, :clicks)
  end

  def import_location_trackings_params
    params.require(:location_trackings).permit(:file)
  end
end
