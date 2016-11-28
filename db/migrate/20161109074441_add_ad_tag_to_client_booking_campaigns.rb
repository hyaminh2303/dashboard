class AddAdTagToClientBookingCampaigns < ActiveRecord::Migration
  def change
    add_column :client_booking_campaigns, :ad_tag, :text
  end unless column_exists?(:client_booking_campaigns, :ad_tag)
end
