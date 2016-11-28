class AddNameToLocationTrackings < ActiveRecord::Migration
  def change
    add_column :location_trackings, :name, :string, after: :id
  end
end
