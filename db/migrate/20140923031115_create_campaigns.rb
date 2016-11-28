class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name,              size: 255
      t.belongs_to :advertiser,    size: 11
      t.date :active_at
      t.date :expire_at
      t.integer :target_click, default: 0
      t.integer :target_impression, default: 0
      t.integer :revenue_type, default: 0

      t.belongs_to :user
      t.timestamps
    end
  end
end
