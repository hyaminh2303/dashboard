class CreateBannerTypeDspMapping < ActiveRecord::Migration
  def change
    create_table :banner_type_dsp_mapping do |t|
      t.belongs_to :banner_type, index: true
      t.integer :dsp_id
      t.integer :banner_type_dsp_id
      t.string :banner_type_code
    end if !(table_exists? :banner_type_dsp_mapping)
  end
end
