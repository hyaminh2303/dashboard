class CreateCountryDspMapping < ActiveRecord::Migration
  def change
    create_table :country_dsp_mapping do |t|
      t.belongs_to :country
      t.integer :dsp_id
      t.integer :country_dsp_id
    end
    add_index :country_dsp_mapping, :country_id
  end
end
