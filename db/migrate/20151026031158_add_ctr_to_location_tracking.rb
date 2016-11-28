class AddCtrToLocationTracking < ActiveRecord::Migration
  def change
    add_column :location_trackings, :ctr, :float, null: false, default: 0 if !column_exists?(:location_trackings, :ctr)
  end
end
