class AddSubTotalSettingIdToSubTotals < ActiveRecord::Migration
  def change
    add_column :sub_totals, :sub_total_setting_id, :integer
  end
end
