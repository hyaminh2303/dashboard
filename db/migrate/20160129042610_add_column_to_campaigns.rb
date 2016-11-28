class AddColumnToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :signed_io, :string
    add_column :campaigns, :is_attached_io, :boolean, default: false
  end
end
