class AddHasLocationBreakdownToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :has_location_breakdown, :boolean
  end
end
