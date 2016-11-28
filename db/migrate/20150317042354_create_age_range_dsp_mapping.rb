class CreateAgeRangeDspMapping < ActiveRecord::Migration
  def change
    create_table :age_range_dsp_mapping do |t|
      t.belongs_to :age_range, index: true
      t.integer :dsp_id
      t.integer :age_range_dsp_id
      t.string :age_range_code
    end
  end
end
