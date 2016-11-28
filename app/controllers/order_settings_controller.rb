class OrderSettingsController < ApplicationController

  def show
  end

  def update_all
    setting = SettingUpdater.new(setting_params)
    setting.update(setting_params[:logo].present?)

    redirect_to action: "show"
  end

  private

  def setting_params
    params.permit(:slogan, :address, :terms_and_conditions, :authorization, :logo, :amendment)
  end
end