class TotalCampaignStats < BaseStats

  def budget_spent
    Hash[Campaign.joins(:daily_trackings).select("SUM( CASE WHEN revenue_type = 1 THEN #{Campaign.table_name}.unit_price_in_usd * #{DailyTracking.table_name}.clicks ELSE #{Campaign.table_name}.unit_price_in_usd * #{DailyTracking.table_name}.views/1000 END ) as budget_spent, #{DailyTracking.table_name}.date").where(DailyTracking.table_name.to_sym => {date: @start_date..@end_date}).group("#{DailyTracking.table_name}.date").belong_to(@user).search_name(@name_kw).map { |m| [m.date.to_time.to_i*1000, m[@data_type].to_f.round(2)/100] }]
  end

  def field_stats(field)
    Hash[Campaign.joins(:daily_trackings).select("SUM(#{field}) AS #{field}, date").where(daily_trackings: {date: @start_date..@end_date}).group(:date).belong_to(@user).search_name(@name_kw).map { |m| [m.date.to_time.to_i*1000, m[@data_type]] if m.date.present? }]
  end
end