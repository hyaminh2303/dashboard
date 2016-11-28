class CampaignSummariesController < AuthorizationController
  def monthly
    @monthly_campaign_summary = CampaignSummary.monthly
    @sales_by_country = SalesByCountry.monthly_campaign
    @platform_usage = PlatformUsage.monthly_campaign

    @platform_monthly_report = Reports::PlatformMonthlyReport.new
    render xlsx: 'monthly', filename: "monthly_campaign_summary_#{Time.now.strftime(Date::DATE_FORMATS[:month_short]).parameterize('_')}"
  end
end
