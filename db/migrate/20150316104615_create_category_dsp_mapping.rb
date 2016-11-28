class CreateCategoryDspMapping < ActiveRecord::Migration
  def change
    create_table :category_dsp_mapping do |t|
      t.belongs_to :category
      t.integer :dsp_id
      t.integer :category_dsp_id
      t.string :category_code
      t.integer :parent_id
    end
    add_index :category_dsp_mapping, :category_id
  end
end
