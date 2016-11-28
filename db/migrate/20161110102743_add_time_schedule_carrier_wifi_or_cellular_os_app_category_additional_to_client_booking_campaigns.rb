class AddTimeScheduleCarrierWifiOrCellularOsAppCategoryAdditionalToClientBookingCampaigns < ActiveRecord::Migration
  def change
    add_column(:client_booking_campaigns, :time_schedule, :text) unless column_exists?(:client_booking_campaigns, :time_schedule)
    add_column(:client_booking_campaigns, :carrier, :text) unless column_exists?(:client_booking_campaigns, :carrier)
    add_column(:client_booking_campaigns, :wifi_or_cellular, :string) unless column_exists?(:client_booking_campaigns, :wifi_or_cellular)
    add_column(:client_booking_campaigns, :os, :string) unless column_exists?(:client_booking_campaigns, :os)
    add_column(:client_booking_campaigns, :app_category, :string)  unless column_exists?(:client_booking_campaigns, :app_category)
    add_column(:client_booking_campaigns, :additional, :text) unless column_exists?(:client_booking_campaigns, :additional)
  end
end
