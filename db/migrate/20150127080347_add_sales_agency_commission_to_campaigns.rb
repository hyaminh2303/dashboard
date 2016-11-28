class AddSalesAgencyCommissionToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :sales_agency_commission, :string
  end
end
