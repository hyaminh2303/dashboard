class AddCountryCodeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :country_code, :string, limit: 2, after: :agency_id
  end
end
