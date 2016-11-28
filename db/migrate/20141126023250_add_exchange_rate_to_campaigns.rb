class AddExchangeRateToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :exchange_rate, :float
  end
end
