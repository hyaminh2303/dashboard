json.array!(@agencies) do |agency|
  json.extract! agency, :id, :name, :country_code, :email
  json.url agency_url(agency, format: :json)
end
