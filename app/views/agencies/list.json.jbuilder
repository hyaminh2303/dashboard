json.draw @dt.draw
json.data @dt.data do |d|
  json.id d.id
  json.name d.name
  json.email d.email
  json.country d.country_display_name
  json.hide_finance d.hide_finance
  json.enabled d.enabled

  json.clients d.clients.filter_clients(d.id, params[:filter]).order(@dt.order) do |c|
    json.id c.id
    json.name c.name
    json.email c.email
    json.country c.country_display_name
    json.enabled c.enabled
    json.hide_finance c.hide_finance
    json.parent_id c.parent_id
  end
end
json.recordsTotal @dt.records_total
json.recordsFiltered @dt.records_total
