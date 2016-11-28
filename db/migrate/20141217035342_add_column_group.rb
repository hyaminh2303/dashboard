class AddColumnGroup < ActiveRecord::Migration
  def up
    change_table :daily_trackings do |t|
      t.belongs_to :group, index: true, null: true

      t.remove :created_at
      t.remove :updated_at
    end

    change_table :campaigns do |t|
      t.boolean :has_ads_group, default: true, null: false, after: :has_location_breakdown
    end
  end

  def down
    change_table :daily_trackings do |t|
      t.remove :group_id
      t.timestamps
    end

    change_table :campaigns do |t|
      t.remove :has_ads_group
    end
  end
end
