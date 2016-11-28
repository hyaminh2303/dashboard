class AddTermsAndConditionsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :terms_and_conditions, :text
  end
end
