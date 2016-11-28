class AddAuthorizationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :authorization, :text
  end
end
