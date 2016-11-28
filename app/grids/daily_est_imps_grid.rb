class DailyEstImpsGrid
  include Datagrid

  scope do
    DailyEstImp
  end

  filter(:country_code, :enum, header: 'Country', select: Country.all, include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 1)
  filter(:banner_size_id, :enum, include_blank: 'Select All', :select => proc { BannerSize.pluck(:name, :id) } )

  column(:country_code)
  column(:country_name)
  column(:banner_size)
  column(:impression)

  column(:actions, :html => true) do |model|
    render :partial => 'daily_est_imps/actions', :locals => {:model => model}
  end
end
