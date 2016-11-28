class CreateLocationListsLocations < ActiveRecord::Migration
  def change
    create_table :location_lists_locations do |t|
      t.belongs_to :location
      t.belongs_to :location_list
    end
  end
end
