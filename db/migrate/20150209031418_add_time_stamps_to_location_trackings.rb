class AddTimeStampsToLocationTrackings < ActiveRecord::Migration
  def up
    add_timestamps(:location_trackings)
  end

  def down
    remove_timestamps(:location_trackings)
  end
end
