class ChangeLongitudeLatitudeToDecimal < ActiveRecord::Migration
  def up
    change_table :locations do |t|
      t.change :longitude,  :decimal, precision: 11, scale: 8, null: false, default: 0.0
      t.change :latitude,   :decimal, precision: 11, scale: 8, null: false, default: 0.0
    end
  end

  def down
    change_table :locations do |t|
      t.change :longitude,  :float
      t.change :latitude,   :float
    end
  end
end
