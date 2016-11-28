class PlatformUsage < ActiveRecord::Tableless

  column :name, :string
  column :views, :integer
  column :spend, :float

  scope :monthly_campaign, -> do
    self.find_by_sql DailyTracking.joins(:platform).monthly_campaign.select("#{Platform.table_name}.name, SUM(views) as views, SUM(spend) as spend, platform_id").group(:platform_id).all.to_sql
  end
end