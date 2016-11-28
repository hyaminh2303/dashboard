class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :country
      t.string :city
      t.integer :client_booking_campaign_id

      t.timestamps
    end
    add_index :places, :client_booking_campaign_id
  end unless (table_exists? :places)
end
