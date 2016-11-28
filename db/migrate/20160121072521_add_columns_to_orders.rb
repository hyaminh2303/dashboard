class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :agency_id, :integer
    add_column :orders, :sale_manager_id, :integer
  end
end
