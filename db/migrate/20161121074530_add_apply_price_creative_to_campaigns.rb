class AddApplyPriceCreativeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :apply_price_creative, :boolean, default: false
  end
end
