class AddCategoryToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :category, index: true
  end
end
