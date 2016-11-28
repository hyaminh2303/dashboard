class SalesByCountry < ActiveRecord::Tableless

  column :country_code, :string
  column :total_revenue, :float

  scope :monthly_campaign, -> do
    self.find_by_sql "SELECT country_code,  SUM(budget) AS total_revenue FROM (" + CampaignSummary.monthly.to_sql + ") RESULTS GROUP BY country_code"
  end

  def total_revenue_as_money
    Money.new(total_revenue)
  end
end