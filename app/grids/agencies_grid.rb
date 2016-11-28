class AgenciesGrid

  include Datagrid

  scope do
    Agency
  end

  filter(:name, :string) {|value| where("name like '%#{value}%'")}
  filter(:email, :string) {|value| where("email like '%#{value}%'")}
  filter(:country_code, :enum, select: Country.all, header: I18n.t('models.agency.fields.country_code'), html: {:class => 'form-control select2-static'})

  column(:name, html: true) do |model|
    link_to model.name, agency_path(model)
  end
  column(:country) do |model|
    model.country_display_name
  end
  column(:email, html: true) do |model|
    mail_to model.email
  end
  column(:enabled, html: true, class: 'text-center') do |model|
    if model.enabled?
      link_to content_tag('i', '', :class => 'ion-checkmark-circled').html_safe,
              disable_agency_path(model), :method => :post, :class => 'text-green', :title => 'Enabled - Click to disable'
    else
      link_to content_tag('i', '', :class => 'ion-close-circled').html_safe,
              enable_agency_path(model), :method => :post, :class => 'text-red', :title => 'Disabled - Click to enable'
    end
  end

  column(:actions, :html => true) do |model|
    render :partial => 'agencies/actions', :locals => {:model => model}
  end
end
