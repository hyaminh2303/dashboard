class RenameColumnBudgetPercentToValueInSubTotalSettings < ActiveRecord::Migration
  def change
    rename_column :sub_total_settings, :budget_percent, :value
  end
end
