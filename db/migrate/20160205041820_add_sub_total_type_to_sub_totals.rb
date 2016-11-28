class AddSubTotalTypeToSubTotals < ActiveRecord::Migration
  def change
    add_column :sub_totals, :sub_total_type, :integer
  end
end
