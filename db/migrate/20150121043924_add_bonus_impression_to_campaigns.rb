class AddBonusImpressionToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :bonus_impression, :decimal, precision: 5, scale: 2, after: :discount
  end
end
