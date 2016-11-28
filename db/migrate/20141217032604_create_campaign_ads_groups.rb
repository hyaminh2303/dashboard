class CreateCampaignAdsGroups < ActiveRecord::Migration
  def change
    create_table :campaign_ads_groups do |t|
      t.belongs_to :campaign,   index: true,      null: false
      t.string :name,           default: '',      null: false, size: 255
      t.string :description,    default: '',                   size: 255
      t.boolean :is_default,    default: false,   null: false
      t.timestamps
    end
  end
end
