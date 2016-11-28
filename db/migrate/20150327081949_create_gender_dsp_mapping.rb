class CreateGenderDspMapping < ActiveRecord::Migration
  def change
    create_table :gender_dsp_mapping do |t|
      t.belongs_to :gender, index: true
      t.integer :dsp_id
      t.integer :gender_dsp_id
      t.string :gender_code
    end if !(table_exists? :gender_dsp_mapping)
  end
end
