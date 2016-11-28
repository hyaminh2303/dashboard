json.records do
  json.array! @sale_managers, :id, :name, :phone, :address, :email
end
json.count @total