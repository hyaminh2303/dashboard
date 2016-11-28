class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name,       size: 255
      t.string :address,    size: 255
      t.string :zip_code,   size: 255
      t.string :country_code, size: 255
      t.float  :longitude
      t.float  :latitude

      t.belongs_to :user
      t.string :status

      t.timestamps
    end
  end
end
