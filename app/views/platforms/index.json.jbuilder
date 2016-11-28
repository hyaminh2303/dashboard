json.records do
  json.array! @platforms, :id, :name, :views, :clicks, :budget_spent, :ctr, :has_campaigns
end
json.stats do
  json.total Platform.count
  json.views @daily_tracking_stats.views
  json.clicks @daily_tracking_stats.clicks
  json.budget_spent @daily_tracking_stats.budget_spent
  json.ctr @daily_tracking_stats.ctr
end
