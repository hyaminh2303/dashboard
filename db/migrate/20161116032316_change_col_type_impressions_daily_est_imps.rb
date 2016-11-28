class ChangeColTypeImpressionsDailyEstImps < ActiveRecord::Migration
  def change
    change_column :daily_est_imps, :impression,  :float
  end
end
