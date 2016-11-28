class CountryCostsGrid
  include Datagrid

  scope do
    CountryCost
  end

  filter(:country_code, :enum, header: 'Country', select: CountryCost.pluck(:country_name, :country_code), include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 1)

  column(:country_code)
  column(:country_name)
  column(:population)
  column(:cpm)
  column(:cpc)

  column(:actions, :html => true) do |model|
    render :partial => 'country_costs/actions', :locals => {:model => model}
  end
end
