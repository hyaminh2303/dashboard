class AppTrackingsController < ApplicationController
  include ApplicationHelper

  before_action :set_campaign, only: [:index, :new, :edit, :create, :update, :import, :destroy, :destroy_all]
  before_action :set_date, only: [:index, :new, :create, :edit, :update, :import, :destroy]
  before_action :set_report_type, only: [:index, :new, :create, :edit, :update, :import, :destroy]
  before_action :set_app_tracking, only: [:show, :edit, :update, :destroy]
  before_action :init_error_messages, only: :import
  skip_authorize_resource only: [:heat]

  def index
    @title = I18n.translate('views.app_trackings.index.title')
    trackings = @campaign.app_trackings
    @number_of_trackings = trackings.length
    @grid = AppTrackingsGrid.new(params[:app_tracking_grid]) do
      trackings.page(params[:page]).per(10)
    end
    @row = params[:page].nil? ? 0 : (params[:page].to_i - 1) * 10
  end

  def show
    @title = I18n.t('views.app_trackings.show.title')
  end

  def new
    @title = I18n.t('views.app_trackings.new.title')
    @app_tracking = AppTracking.new
  end

  def edit
    @title = I18n.t('views.app_trackings.edit.title')
  end

  def heat
  end

  def create
    @app_tracking = AppTracking.new(app_tracking_params)
    @app_tracking.campaign_id = @campaign.id
    @app_tracking.date = @date
    if @app_tracking.save
      redirect_to_index I18n.t('messages.create.success', class_name: I18n.t('models.app_tracking.name'))
    else
      render :new
    end
  end

  def update
    if @app_tracking.update(app_tracking_params)
      redirect_to_index I18n.t('messages.update.success', class_name: I18n.t('models.app_trackings.name'))
    else
      render :edit
    end
  end

  def destroy
    @app_tracking.destroy
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.app_tracking.name'))
  end

  def destroy_all
    AppTracking.where(campaign_id: @campaign.id).destroy_all
    redirect_to_index I18n.t('messages.destroy.success', class_name: I18n.t('models.app_tracking.name'))
  end

  def import
    @title = I18n.translate('views.app_trackings.import.title')
    if request.post?
      require 'csv'
      AppTracking.where(campaign_id: @campaign.id).destroy_all
      uploader = AppTrackingUploader.new
      uploader.store!(import_app_trackings_params[:file])
      encoding = get_file_encoding("#{Rails.public_path}#{uploader.url}")
      unless import_trackings(uploader, encoding)
        redirect_to_index_with_alert @error_lines
        return
      end
      redirect_to_index I18n.t('messages.create.success', class_name: I18n.t('models.app_tracking.name'))
    end
  end

  def import_post
  end

  def set_app_tracking
    @app_tracking = AppTracking.find(params[:id])
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
    redirect_to({ action: 'index' }, notice: notice)
  end

  def redirect_to_index_with_alert(lines_array)
    redirect_to({ action: 'index' }, alert: I18n.t('models.app_tracking.validate.error_on_lines', lines: lines_array.join(', ')))
  end

  def import_trackings(uploader, encode = 'UTF-8')
    result = true
    csv_path = "#{Rails.public_path}#{uploader.url}"
    trackings = []
    current_line = 2

    CSV.foreach(csv_path, headers: true, encoding: encode) do |row|
      if !row.empty? && !row['App'].nil?
        tracking = AppTracking.new(name: row['App'],
                                   campaign_id: params[:campaign_id],
                                   date: @date,
                                   views: get_value(row['Views']),
                                   clicks: get_value(row['Clicks'])
                                  )
        set_error_messages(tracking, current_line) ? result = false : trackings << tracking
      end
      current_line += 1
    end
    AppTracking.import(trackings) if result
    result
  end

  def set_error_messages(model, csv_line)
    return false if model.valid?

    Rails.logger.error model.errors.full_messages
    model.errors.full_messages.each do |msg|
      @error_messages << "Line #{csv_line}: #{msg}"
      @error_lines << csv_line unless @error_lines.include? csv_line
    end
    true
  end

  def get_value(field)
    return -1 if field == '' || field.nil?
    field
  end

  def get_file_encoding(path)
    CharlockHolmes::EncodingDetector.detect(File.read(path))[:encoding]
  end

  def app_tracking_params
    params.require(:app_tracking).permit(:name, :campaign_id, :date, :views, :clicks)
  end

  def import_app_trackings_params
    params.require(:app_trackings).permit(:file)
  end
end
