class AddStatusToClientBookingCampaigns < ActiveRecord::Migration
  def change
    add_column(:client_booking_campaigns, :status, :integer, default: 0) unless column_exists?(:client_booking_campaigns, :status)
  end
end
