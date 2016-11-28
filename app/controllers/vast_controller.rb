class VastController < ApplicationController
  before_action :vast_params, only: [:create]

  def index
    @vast = Vast.new
  end

  def create
    vast_file = params[:vast][:file]
    if vast_file
      @vast = VastParser.parse(vast_file)
      if @vast.errors.none?
        flash[:notice] = 'Load Vast from file successfully'
      else
        flash.delete(:notice)
      end
    else
      @vast = Vast.new(vast_params)
      need_commit_to_s3 = params[:commit_to_s3].to_i == 1
      @vast.generate(need_commit_to_s3)
    end
    render 'index'
  end

  private

  def vast_params
    params.require(:vast).permit(:ad_system, :ad_title, :description,
                                 :creative_type, :has_companion_ad,
                                impressions_attributes: [:url],
                                error_urls_attributes: [:url],
                                linear_ads_attributes: [
                                          :skipoffset, :duration, :click_through,
                                          click_trackings_attributes: [:url],
                                          media_files_attributes: [:url, :width, :height, :media, :media_type],
                                          tracking_events_attributes: [:event, :url]],
                                companion_ads_attributes: [
                                          :width, :height, :click_through,
                                          click_trackings_attributes: [:url],
                                          ad_resources_attributes: [:resource_type, :url, :media],
                                          tracking_events_attributes: [:event, :url]],
                                non_linear_ads_attributes: [
                                          non_linear_resources_attributes: [
                                                  :width, :height, :click_through,
                                                  click_trackings_attributes: [:url],
                                                  ad_resources_attributes: [:resource_type, :url, :media]
                                                                           ],
                                          tracking_events_attributes: [:event, :url]]
                                )
  end
end
