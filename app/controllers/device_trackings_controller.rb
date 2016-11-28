require 'charlock_holmes'

class DeviceTrackingsController < ApplicationController
  include ApplicationHelper

  before_action :set_campaign,            only: [:index, :new, :edit, :create, :update, :import, :destroy, :destroy_all]

  before_action :set_date,                only: [:index, :new, :create, :edit, :update, :import, :destroy]
  before_action :set_report_type,         only: [:index, :new, :create, :edit, :update, :import, :destroy]

  before_action :set_device_tracking,   only: [:show, :edit, :update, :destroy]
  before_action :init_error_messages,     only: :import
  skip_authorize_resource only: [:heat]

  def index
    @title = I18n.translate('views.device_trackings.index.title')
    trackings = @campaign.device_trackings
    ads_group_hidden = trackings.where('campaign_ads_group_id IS NOT NULL').first.nil?
    @number_of_trackings = trackings.length
    if (!ads_group_hidden)
      @grid = DeviceGroupTrackingsGrid.new(params[:device_tracking_grid]) do
        trackings.page(params[:page]).per(10)
      end
    else
      @grid = DeviceTrackingsGrid.new(params[:device_tracking_grid]) do
        trackings.page(params[:page]).per(10)
      end
    end

    @row = params[:page].nil? ? 0 : (params[:page].to_i - 1) * 10
  end

  def show
    @title = I18n.t('views.device_trackings.show.title')
  end

  def new
    @title = I18n.t('views.device_trackings.new.title')
    @device_tracking = DeviceTracking.new()
  end

  def edit
    @title = I18n.t('views.device_trackings.edit.title')
  end

  def heat
  end

  def create
    @device_tracking = DeviceTracking.new(device_tracking_params)
    @device_tracking.campaign_id = @campaign.id
    @device_tracking.date = @date
    if @device_tracking.save
      redirect_to_index I18n.t('messages.create.success', class_name: I18n.t('models.device_tracking.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /os_trackings/1
  def update
    if @device_tracking.update(device_tracking_params)
      redirect_to_index I18n.t('messages.update.success', class_name: I18n.t('models.device_tracking.name'))
    else
      render :edit
    end
  end

  def destroy
    @device_tracking.destroy
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.device_tracking.name'))
  end

  def destroy_all
    DeviceTracking.where(campaign_id: @campaign.id).destroy_all
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.device_tracking.name'))
  end

  def import
    @title = I18n.translate('views.device_trackings.import.title')

    if request.post?
      require 'csv'
      uploader = DeviceTrackingUploader.new
      uploader.store!(import_device_trackings_params[:file])

      # Get file encoding
      encoding = get_file_encoding "#{Rails.public_path}#{uploader.url}"

      # Process location first
      unless import_campaign_ads_group uploader, encoding
        redirect_to_index_with_alert @error_lines
        return
      end

      # Destroy all imported data
      DeviceTracking.where(campaign_id: @campaign.id).destroy_all

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

  def set_device_tracking
    @device_tracking = DeviceTracking.find(params[:id])
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

  def import_campaign_ads_group(uploader, encode = 'UTF-8')
    result = true
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and (!(row['Ad Group'].nil? or row['Ad Group'].empty?))
        campaign_ad_group = CampaignAdsGroup.where(name: row['Ad Group'], campaign_id: params[:campaign_id]).first
        if campaign_ad_group.nil?
          set_no_ads_group_error_message current_line
          result = false
        end
      end
      current_line += 1
    end
    result
  end

  def import_trackings(uploader, encode = 'UTF-8')
    result = true
    trackings = []
    current_line = 2

    CSV.foreach("#{Rails.public_path}#{uploader.url}", :headers => true, :encoding => encode) do |row|
      if !row.empty? and !(row['Views'].nil? and row['Clicks'].nil? and row['# of device IDs'].nil? and row['Frequency cap'].nil? and row['Dates'].nil?)
        tracking = DeviceTracking.new campaign_id: params[:campaign_id],
                                      campaign_ads_group_id: CampaignAdsGroup.where(name: row['Ad Group'], campaign_id: params[:campaign_id]).first.nil? ? nil : CampaignAdsGroup.where(name: row['Ad Group'], campaign_id: params[:campaign_id]).first.id,
                                      date: @date,
                                      views: row['Views'],
                                      clicks: row['Clicks'],
                                      number_of_device_ids: row['# of device IDs'],
                                      frequency_cap: row['Frequency cap'],
                                      date_range: row['Dates']
        set_error_messages(tracking, current_line) ? result = false : trackings << tracking
      end

      current_line += 1
    end

    if result
      DeviceTracking.import trackings
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


  def set_no_ads_group_error_message(csv_line)
    @error_messages << "Ad group at line #{csv_line} does not exist"
    unless @error_lines.include? csv_line
      @error_lines << csv_line
    end
  end


  def get_file_encoding(path)
    CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]
  end

  # Only allow a trusted parameter "white list" through.
  def device_tracking_params
    params.require(:device_tracking).permit(:name, :campaign_id, :date, :date_range, :views, :clicks, :number_of_device_ids, :frequency_cap, :campaign_ads_group_id)
  end

  def import_device_trackings_params
    params.require(:device_trackings).permit(:file)
  end
end
