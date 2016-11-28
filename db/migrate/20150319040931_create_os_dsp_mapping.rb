class CreateOsDspMapping < ActiveRecord::Migration
  def change
    create_table :os_dsp_mapping do |t|
      t.belongs_to :os, index: true
      t.integer :dsp_id
      t.integer :os_dsp_id
      t.string :os_code
    end
  end
end
