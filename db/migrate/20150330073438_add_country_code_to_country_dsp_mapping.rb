class AddCountryCodeToCountryDspMapping < ActiveRecord::Migration
  def change
    add_column :country_dsp_mapping, :country_code, :string if !column_exists?(:country_dsp_mapping, :country_code)
  end
end
