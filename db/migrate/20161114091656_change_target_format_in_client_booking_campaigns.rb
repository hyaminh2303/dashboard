class ChangeTargetFormatInClientBookingCampaigns < ActiveRecord::Migration
  def change
    change_column :client_booking_campaigns, :target, :integer
  end
end
