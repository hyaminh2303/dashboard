class AddParentIdToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :parent_id, :integer, null: true, index: true
  end
end
