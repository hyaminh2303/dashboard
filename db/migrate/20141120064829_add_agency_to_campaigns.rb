class AddAgencyToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :agency, index: true, after: :name
  end
end
