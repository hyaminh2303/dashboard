class CreateAppTrackings < ActiveRecord::Migration
  def change
    create_table :app_trackings do |t|

      t.belongs_to :campaign, index: true
      t.string :name, size: 255
      t.date :date
      t.integer :views, default: 0
      t.integer :clicks, default: 0

      t.timestamps
    end
  end
end
