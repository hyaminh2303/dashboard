class AddUnitPriceInUsdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :unit_price_in_usd, :integer
  end
end
