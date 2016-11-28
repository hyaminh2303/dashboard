class AddDiscountToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :discount, :decimal, precision: 5, scale: 2
  end
end
