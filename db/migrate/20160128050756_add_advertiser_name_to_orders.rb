class AddAdvertiserNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :advertiser_name, :string
  end
end
