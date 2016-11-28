class AddZoneToTimezones < ActiveRecord::Migration
  def change
    add_column :timezones, :zone, :string if !column_exists?(:timezones, :zone)
  end
end
