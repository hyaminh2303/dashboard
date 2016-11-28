class CreateTimezoneDspMapping < ActiveRecord::Migration
  def change
    create_table :timezone_dsp_mapping do |t|
      t.belongs_to :timezone, index: true
      t.integer :dsp_id
      t.integer :timezone_dsp_id
      t.string :timezone_code
    end if !(table_exists? :timezone_dsp_mapping)
  end
end
