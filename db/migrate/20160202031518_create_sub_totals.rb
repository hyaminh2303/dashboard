class CreateSubTotals < ActiveRecord::Migration
  def change
    create_table :sub_totals do |t|
      t.integer :order_id
      t.float :budget_percent
      t.float :budget_value

      t.timestamps
    end
  end
end
