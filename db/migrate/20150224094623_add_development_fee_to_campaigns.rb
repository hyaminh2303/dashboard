class AddDevelopmentFeeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :development_fee, :decimal, precision: 10, scale: 2
  end
end
