class AddTotalBudgetToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_budget, :float
  end
end
