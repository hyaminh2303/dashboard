class RemoveNameCampaignIdStatusPublisherIdFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :name, :string
    remove_column :orders, :status, :string
    remove_column :orders, :campaign_id, :integer
    remove_column :orders, :publisher_id, :integer
  end
end
