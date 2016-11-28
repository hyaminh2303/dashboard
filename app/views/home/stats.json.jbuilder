json.draw params[:draw]
json.recordsTotal @grid.assets.total_count
json.recordsFiltered @grid.assets.total_count

json.data do
  json.array! @total_tracking do |model|
    json.DT_RowData do
      #json.set! :nclick, "loadRow(#{model.id.present? ? model.id : 0 }, '#{model.has_attribute?(:name) ? model.name : 'Total' }', '#{number_with_delimiter(model.views)}', '#{number_with_delimiter(model.clicks)}', '#{model.budget_spent.format}')"
      json.campaign_id model.id.present? ? model.id : 0
      json.name model.has_attribute?(:name) ? model.name : 'Total'
      json.views number_with_delimiter(model.views)
      json.clicks number_with_delimiter(model.clicks)
      json.budget_spent model.budget_spent.format
    end
    json.status datagrid_value(@grid, :status, model)
    json.name datagrid_value(@grid, :name, model)
    json.views datagrid_value(@grid, :views, model)
    json.clicks datagrid_value(@grid, :clicks, model)
    json.ctr datagrid_value(@grid, :ctr, model)
    json.unit_price datagrid_value(@grid, :unit_price, model)
    json.actions datagrid_value(@grid, :actions, model)
  end

  json.array! @grid.assets do |model|
    json.DT_RowData do
      #json.set! :nclick, "loadRow(#{model.id.present? ? model.id : 0 }, '#{model.has_attribute?(:name) ? model.name : 'Total' }', '#{number_with_delimiter(model.views)}', '#{number_with_delimiter(model.clicks)}', '#{model.budget_spent.format}')"
      json.campaign_id model.id.present? ? model.id : 0
      json.name model.has_attribute?(:name) ? model.name : 'Total'
      json.views number_with_delimiter(model.views)
      json.clicks number_with_delimiter(model.clicks)
      json.budget_spent model.budget_spent.format
    end
    json.status datagrid_value(@grid, :status, model)
    json.name datagrid_value(@grid, :name, model)
    json.views datagrid_value(@grid, :views, model)
    json.clicks datagrid_value(@grid, :clicks, model)
    json.ctr datagrid_value(@grid, :ctr, model)
    json.unit_price datagrid_value(@grid, :unit_price, model)
    json.actions datagrid_value(@grid, :actions, model)
  end
end
