require 'charlock_holmes'

class OsTrackingsController < ApplicationController

  include ApplicationHelper

  before_action :set_campaign,            only: [:index, :new, :edit, :create, :update, :import, :destroy, :destroy_all]

  before_action :set_date,                only: [:index, :new, :create, :edit, :update, :import, :destroy]
  before_action :set_report_type,         only: [:index, :new, :create, :edit, :update, :import, :destroy]

  before_action :set_os_tracking,   only: [:show, :edit, :update, :destroy]
  before_action :init_error_messages,     only: :import
  skip_authorize_resource only: [:heat]

  def index
    @title = I18n.translate('views.os_trackings.index.title')
    trackings = @campaign.os_trackings
    @number_of_trackings = trackings.length
    @grid = OsTrackingsGrid.new(params[:os_tracking_grid]) do
      trackings.page(params[:page]).per(10)
    end
    @row = params[:page].nil? ? 0 : (params[:page].to_i - 1) * 10
  end

  def show
    @title = I18n.t('views.os_trackings.show.title')
  end

  def new
    @title = I18n.t('views.os_trackings.new.title')
    @os_tracking = OsTracking.new()
  end

  def edit
    @title = I18n.t('views.os_trackings.edit.title')
  end

  def heat
  end

  def create
    @os_tracking = OsTracking.new(os_tracking_params)
    @os_tracking.campaign_id = @campaign.id
    @os_tracking.date = @date
    if @os_tracking.save
      redirect_to_index I18n.t('messages.create.success', class_name: I18n.t('models.os_tracking.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /os_trackings/1
  def update
    if @os_tracking.update(os_tracking_params)
      redirect_to_index I18n.t('messages.update.success', class_name: I18n.t('models.os_tracking.name'))
    else
      render :edit
    end
  end

  def destroy
    @os_tracking.destroy
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.os_tracking.name'))
  end

  def destroy_all
    OsTracking.where(campaign_id: @campaign.id).destroy_all
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.os_tracking.name'))
  end

  def import
    @title = I18n.translate('views.os_trackings.import.title')

    if request.post?
      require 'csv'
      uploader = OsTrackingUploader.new
      uploader.store!(import_os_trackings_params[:file])

      # Get file encoding
      encoding = get_file_encoding "#{Rails.public_path}#{uploader.url}"

      # Process location first
      unless import_operating_system uploader, encoding
        redirect_to_index_with_alert @error_lines
        return
      end

      # Destroy all imported data
      OsTracking.where(campaign_id: @campaign.id).destroy_all

      # Process CSV
      unless import_trackings uploader, encoding
        redirect_to_index_with_alert @error_lines
        return
      end

      redirect_to_index I18n.t('messages.create.success', class_name: I18n.t('models.os_tracking.name'))
    end

  end

  def import_post
  end

  def set_os_tracking
    @os_tracking = OsTracking.find(params[:id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_report_type
    @report_type = [['By OS', campaign_os_trackings_path],
                    ['By Creatives', campaign_creative_trackings_path],
                    ['By Device ID', campaign_device_trackings_path],
                    ['By App', campaign_app_trackings_path],
                    ['By Rich Media', campaign_rich_media_trackings_path]]
  end


  def set_date
    @date = if params[:date].nil?
              Date.yesterday
            else
              Date.parse(params[:date])
            end
    @date = @campaign.active_at if @date < @campaign.active_at
    @date = @campaign.expire_at if @date > @campaign.expire_at
  end

  def init_error_messages
    @error_messages = []
    @error_lines = []
  end

  def redirect_to_index(notice)
    redirect_to({action: 'index'}, notice: notice)
  end

  def redirect_to_index_with_alert(lines_array)
    redirect_to({action: 'index'}, alert: I18n.t('models.os_tracking.validate.error_on_lines', lines: lines_array.join(', ')))
  end

  # Init global var @error_messages for view can show error (if any)
  def init_error_messages
    @error_messages = []
    @error_lines = []
  end

  def import_operating_system(uploader, encode = 'UTF-8')
    result = true
    operatingsystems = []
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and !(row['OS'].nil?)
        operatingsystem = OperatingSystem.where(name: row['OS']).first

        if operatingsystem.nil?
          operatingsystem = OperatingSystem.new name: row['OS'],
                                  operating_system_code: row['OS'].upcase

          if set_error_messages operatingsystem, current_line
            # Some errors has been set
            result = false
          else
            # everything are valid
            operatingsystems << operatingsystem
          end
          set_error_messages(operatingsystem, current_line) ? result = false : operatingsystems << operatingsystem
        end
      end
      current_line += 1
    end

    if result
      OperatingSystem.import operatingsystems
    end

    result
  end

  def import_trackings(uploader, encode = 'UTF-8')
    result = true
    trackings = []
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and !(row['OS'].nil? and row['Views'].nil? and row['Clicks'].nil?)
        tracking = OsTracking.new       campaign_id: params[:campaign_id],
                                        operating_system_id: OperatingSystem.where(name: row['OS']).first.id,
                                        date: @date,
                                        views: row['Views'],
                                        clicks: row['Clicks']
        set_error_messages(tracking, current_line) ? result = false : trackings << tracking
      end

      current_line += 1
    end

    if result
      OsTracking.import trackings
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
  def os_tracking_params
    params.require(:os_tracking).permit(:name, :campaign_id, :date, :operating_system_id, :views, :clicks)
  end

  def import_os_trackings_params
    params.require(:os_trackings).permit(:file)
  end
end
