class AddAdvertiserNameToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :advertiser_name, :string, after: :country_code
  end
end
