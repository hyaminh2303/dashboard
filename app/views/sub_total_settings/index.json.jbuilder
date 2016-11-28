json.array!(@sub_total_settings) do |sub_total_setting|
  json.extract! sub_total_setting, :id, :name, :budget_percent
  json.url sub_total_setting_url(sub_total_setting, format: :json)
end
