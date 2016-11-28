class ChangeDailyTrackingsColumnsToNotNull < ActiveRecord::Migration
  def up
    change_column_null :daily_trackings, :views, false
    change_column_null :daily_trackings, :clicks, false
    change_column_null :daily_trackings, :spend, false
  end

  def down
    change_column_null :daily_trackings, :views, true
    change_column_null :daily_trackings, :clicks, true
    change_column_null :daily_trackings, :spend, true
  end
end
