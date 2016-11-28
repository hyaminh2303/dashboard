class CampaignLocationHeat < BaseLocationHeat
  def locations_by_date
    LocationTracking.joins(:location).select("*, IFNULL(SUM(views), 0) as views, IFNULL(SUM(clicks), 0) as clicks").group("#{LocationTracking.table_name}.date, #{LocationTracking.table_name}.location_id").select_by_campaign(@campaign_id).belong_to(@user).select_in_period(@start_date, @end_date).group_by{ |m| m.date}
  end
end