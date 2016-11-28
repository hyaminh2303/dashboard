class AddCanSeeDetailCampaignToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :hide_finance, :boolean, default: false
  end
end
