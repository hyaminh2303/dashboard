class AddColumnToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :is_notified, :boolean, default: false
  end
end
