class DensitiesGrid
  include Datagrid

  scope do
    Density
  end

  filter(:country_code, :enum, header: 'Country', select: CountryCost.pluck(:country_name, :country_code), include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 1)

  column(:country_code)
  column(:city_name)
  column(:density)
  column(:population)
  column(:area)

  column(:actions, :html => true) do |model|
    render :partial => 'densities/actions', :locals => {:model => model}
  end
end
