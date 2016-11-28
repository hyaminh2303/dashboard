class AddSubTotalSettingTypeToSubTotalSettings < ActiveRecord::Migration
  def change
    add_column :sub_total_settings, :sub_total_setting_type, :integer
  end
end
