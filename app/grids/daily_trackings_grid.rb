class DailyTrackingsGrid

  include Datagrid

  attr_accessor :has_ads_group

  scope do
    DailyTracking
  end

  column(:platform_id, order: false, html:true) do |model|
    link_to model.platform.name, platform_path(model.campaign)
  end
  column(:campaign_ads_group, if: proc { |grid| grid.has_ads_group}, order: false, header: I18n.t('views.daily_trackings.header.ads_group'), html:true) do |model|
    # link_to model.campaign_ads_group.name, platform_path(model.campaign)
    model.campaign_ads_group.nil? ? '' : model.campaign_ads_group.name
  end
  column(:date, order: false)
  column(:views, order: false, :html => true) do |model|
    number_with_delimiter model.views
  end
  column(:clicks, order: false, :html => true) do |model|
    number_with_delimiter model.clicks
  end
  column(:ctr, order: false, :html => true) do |model|
    if model.views.present? and model.views >0
      ((model.clicks.to_f / model.views.to_f) * 100).round(2).to_s + "%"
    else
      0
    end
  end
  column(:spend, order: false) do |model|
    Currency.usd(model.spend, :USD).format
  end

  column(:actions, :html => true) do |model|
    render :partial => 'daily_trackings/actions', :locals => {:model => model}
  end
end
