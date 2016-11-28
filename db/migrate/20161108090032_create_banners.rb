class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.integer :client_booking_campaign_id
      t.string :name
      t.text :landing_url
      t.text :image
      t.text :name

      t.timestamps
    end unless (table_exists? :banners)
  end
end
