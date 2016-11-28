class AddAdditionalInformationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :additional_information, :text
  end
end
