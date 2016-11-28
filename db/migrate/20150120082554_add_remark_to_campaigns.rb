class AddRemarkToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :remark, :text
  end
end
