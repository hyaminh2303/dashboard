class CreateCampaignTypes < ActiveRecord::Migration
  def change
    create_table :campaign_types do |t|
      t.string :name
      t.string :campaign_type_code
    end if !(table_exists? :campaign_types)
  end
end
