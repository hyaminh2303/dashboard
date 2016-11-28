class AddCountryCodeToClientBookingCampaigns < ActiveRecord::Migration
  def change
    add_column :client_booking_campaigns, :country_code, :string
  end unless column_exists?(:client_booking_campaigns, :country_code)
end
