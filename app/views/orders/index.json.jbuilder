json.records do
  json.array!(@orders) do |order|
    json.id order.id
    json.created_at order.created_at.strftime(Date::DATE_FORMATS[:default])
    json.campaign_name order.campaign_name
    json.agency order.agency.name
    json.sale_manager order.sale_manager.name
    json.billing_currency order.currency.name
  end
end
json.stats do
  json.total Order.count
end