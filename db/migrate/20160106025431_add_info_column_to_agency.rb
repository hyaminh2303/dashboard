class AddInfoColumnToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :phone, :string
    add_column :agencies, :address, :string
    add_column :agencies, :billing_name, :string
    add_column :agencies, :billing_phone, :string
    add_column :agencies, :billing_address, :string
    add_column :agencies, :billing_email, :string
  end
end
