class ChangeOsToOperatingSystem < ActiveRecord::Migration
  def change
    #rename_column :os, :os_code, :operating_system_code
    #rename_table :os, :operating_systems

    rename_column :os_dsp_mapping, :os_id, :operating_system_id if column_exists?(:os_dsp_mapping, :os_id)
    rename_column :os_dsp_mapping, :os_dsp_id, :operating_system_dsp_id if column_exists?(:os_dsp_mapping, :os_dsp_id)
    rename_column :os_dsp_mapping, :os_code, :operating_system_code if column_exists?(:os_dsp_mapping, :os_code)
    rename_table :os_dsp_mapping, :operating_system_dsp_mapping if column_exists?(:os_dsp_mapping, :operating_system_dsp_mapping)
  end
end
