json.array!(@categories) do |category|
  json.extract! category, :id, :name, :category_code, :parent_id
end
