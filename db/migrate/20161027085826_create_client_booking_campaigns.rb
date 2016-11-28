class CreateClientBookingCampaigns < ActiveRecord::Migration
  def change
    create_table :client_booking_campaigns do |t|
      t.string :banner_type
      t.string :banner_size
      t.text :description
      t.boolean :no_specific_locations, default: false
      t.string :campaign_name
      t.string :advertiser_name
      t.datetime :start_date
      t.datetime :end_date
      t.string :timezone
      t.string :campaign_category
      t.integer :frequency_cap
      t.string :additional_targeting
      t.string :campaign_type
      t.string :target
      t.float :unit_price
      t.float :budget
      t.timestamps
    end
  end unless (table_exists? :client_booking_campaigns)
end