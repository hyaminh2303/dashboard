class BannersController < ApplicationController
  def index
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      @banner
    else
      render json: { error: 'Error while save banner' }
    end
  end

  private

  def banner_params
    params.permit(:name, :landing_url, :image, :client_booking_campaign_id)
  end
end
