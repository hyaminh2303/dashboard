class RenameColumnStarrEndInOrderItems < ActiveRecord::Migration
  def change
    rename_column :order_items, :start, :start_time
    rename_column :order_items, :end, :end_time
  end
end
