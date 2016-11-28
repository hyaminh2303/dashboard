class RenameBudgetValueBudgetPercentFromSubtotals < ActiveRecord::Migration
  def change
    rename_column :sub_totals, :budget_value, :budget
    rename_column :sub_totals, :budget_percent, :value
  end
end
