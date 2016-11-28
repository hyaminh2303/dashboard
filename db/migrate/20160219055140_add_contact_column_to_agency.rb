class AddContactColumnToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :contact_name, :string
    add_column :agencies, :contact_phone, :string
    add_column :agencies, :contact_address, :string
    add_column :agencies, :contact_email, :string
  end
end
