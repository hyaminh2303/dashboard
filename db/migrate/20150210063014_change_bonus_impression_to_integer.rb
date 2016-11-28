class ChangeBonusImpressionToInteger < ActiveRecord::Migration
  def up
    change_column :campaigns, :bonus_impression, :integer
  end

  def down
    change_column :campaigns, :bonus_impression, :decimal, precision: 5, scale: 2
  end
end
