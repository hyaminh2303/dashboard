class CreateClientBookingLocations < ActiveRecord::Migration
  def change
    create_table :client_booking_locations do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :place_id
      t.float :radius

      t.timestamps
    end
  end unless (table_exists? :client_booking_locations)
end
