class CreateDailyTrackings < ActiveRecord::Migration
  def change
    create_table :daily_trackings do |t|
      t.belongs_to :campaign, index: true
      t.belongs_to :platform, index: true
      t.date :date
      t.integer :views, default: 0
      t.integer :clicks, default: 0
      t.decimal :spend, default: 0, precision: 19, scale: 4

      t.timestamps
    end
  end
end
