class AddUserNotifyIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :user_notify_id, :integer
    add_index :campaigns, :user_notify_id
  end
end
