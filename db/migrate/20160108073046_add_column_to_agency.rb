class AddColumnToAgency < ActiveRecord::Migration
  def change
    add_column :agencies, :use_contact_info, :boolean, default: 0
  end
end
