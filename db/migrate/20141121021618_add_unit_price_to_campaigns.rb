class AddUnitPriceToCampaigns < ActiveRecord::Migration
  def change
    add_money :campaigns, :unit_price, after: :expire_at
  end
end
