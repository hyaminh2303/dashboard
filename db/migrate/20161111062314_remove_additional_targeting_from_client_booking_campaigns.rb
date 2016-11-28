class RemoveAdditionalTargetingFromClientBookingCampaigns < ActiveRecord::Migration
  def change
    remove_column(:client_booking_campaigns, :additional_targeting, :string) if column_exists?(:client_booking_campaigns, :additional_targeting)
  end
end
