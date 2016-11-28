class AddLastStatsAtToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :last_stats_at, :date
  end
end
