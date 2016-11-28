class CampaignsGrid

  include Datagrid

  attr_accessor :is_agency, :is_campaign_manager

  scope do
    Campaign.order(created_at: :desc)
  end

  filter(:name, :string, group: 0) {|value| where("name like '%#{value}%'")}
  filter(:campaign_manager, :string, group: 0) {|value| where("campaign_manager like '%#{value}%'")}
  filter(:agency, :enum, select: proc{ Agency.all.map {|m| [m.name, m.id]}}, include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 1)
  filter(:country_code, :enum, header: 'Country', select: Country.all, include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 1)
  filter(:campaign_type, :enum, select: Campaign::CAMPAIGN_TYPES.each_with_index.map{|t, i| [t, i]}, include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 2) do |value|
    self.where(revenue_type: value)
  end
  filter(:expire_on, :enum, select: Campaign.get_expire_preiods.map {|k,v| [k.to_s.titleize, k]}, include_blank: 'Select All', html: {class: 'form-control select2-static'}, group: 2) do |value|
    self.where(expire_at: Campaign.get_expire_preiods[value.to_sym])
  end

  column(:name, html: true) do |model|
    link_to model.name, model.has_ads_group? ? index_campaign_group_stats_path(model) : index_campaign_details_path(model)
  end
  column(:agency, html: true) do |model|
    if current_user.is_agency_or_client?
      model.agency.name
    else
      link_to model.agency.name, agency_path(model.agency)
    end
  end
  column(:active_at, header: 'Active on')
  column(:expire_at, header: 'Expire on', html: true) do |model|
    class_css = (!model.is_notified && model.expire_at <= Date.today) ? 'high-light-date' : ''
    "<div class=#{class_css}> #{model.expire_at}</div>".html_safe
  end
  column(:last_stats_at, header: 'Last stats on', html: true, if: proc{ |grid| grid.is_campaign_manager }) do |model|
    render partial: 'campaigns/stats_at', locals: { model: model }
  end
  column(:campaign_type)
  column(:has_location_breakdown, header: 'Has LBD', html: true) do |model|
    check_box_tag :has_location_breakdown, nil, model.has_location_breakdown, class: 'flat-red', disabled: true
  end
  column(:health_percent, html: true, header: 'Health', custom_class: proc { |column| column.warning_health? ? 'red-column' : 'blue-column' }, if: proc{ |grid| grid.is_campaign_manager }) do |model|
    number_to_percentage(model.health_percent, precision: 2)
  end

  column(:actions, header: '', html: true, if: proc{|grid| grid.is_campaign_manager }) do |model|
    render :partial => 'campaigns/actions', :locals => {:model => model}
  end
end
