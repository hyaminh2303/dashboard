class CreateLocationTrackings < ActiveRecord::Migration
  def change
    create_table :location_trackings do |t|
      t.belongs_to :campaign,   null: false, index: true
      t.date :date,             null: false
      t.belongs_to :location,   null: false, index: true
      t.integer :views,         null: false, default: 0
      t.integer :clicks,        null: false, default: 0
    end
  end
end
