class RemoveTermsAndConditionsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :terms_and_conditions, :text
  end
end
