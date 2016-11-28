class CreateCampaignTypeDspMapping < ActiveRecord::Migration
  def change
    create_table :campaign_type_dsp_mapping do |t|
      t.belongs_to :campaign_type, index: true
      t.integer :dsp_id
      t.integer :campaign_type_dsp_id
      t.string :campaign_type_code
    end if !(table_exists? :campaign_type_dsp_mapping)
  end
end
