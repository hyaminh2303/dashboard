class CreateInterestDspMapping < ActiveRecord::Migration
  def change
    create_table :interest_dsp_mapping do |t|
      t.belongs_to :interest, index: true
      t.integer :dsp_id
      t.integer :interest_dsp_id
      t.string :interest_code
    end
  end
end
