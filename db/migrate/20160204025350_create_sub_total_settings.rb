class CreateSubTotalSettings < ActiveRecord::Migration
  def change
    create_table :sub_total_settings do |t|
      t.string :name
      t.float :budget_percent

      t.timestamps
    end
  end
end
