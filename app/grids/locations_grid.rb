class LocationsGrid

  include Datagrid

  scope do
    LocationTracking
  end

  # filter(:name, :string)
  # filter(:created_at, :date, :range => true)
 
  # column(:name)
  # column(:address)
  # column(:longitude)
  # column(:address)
  # column(:status, :html => true, :class => 'text-center') do |model|
  #   case model.status
  #     when Location::STATUS_PUBLISHED
  #       link_to content_tag('i', '', :class => 'ion-checkmark-circled').html_safe,
  #               expire_location_path(model), :method => :post, :class => 'text-green', :title => 'Published - Click to expire'
  #     when Location::STATUS_EXPIRED
  #       link_to content_tag('i', '', :class => 'ion-close-circled').html_safe,
  #               publish_location_path(model), :method => :post, :class => 'text-red', :title => 'Expired - Click to republish'
  #     else
  #       link_to content_tag('i', '', :class => 'ion-help-circled').html_safe,
  #               publish_location_path(model), :method => :post, :class => 'text-blue', :title => 'Pending - Click to publish'
  #   end
  # end
  # column(:created_at) do |model|
  #   model.created_at.to_date
  # end

  # column(:actions, :html => true) do |model|
  #   render :partial => 'locations/actions', :locals => {:model => model}
  # end
  
  filter(:name, :string) do |keyword|
    self.search_by_keyword(keyword)
  end
  column(:location) do |model|
    model.name
  end
  column(:views, :header => "Views") do |model|
    model.views_count
  end
  column(:clicks, :header => "Clicks") do |model|
    model.clicks_count
  end
  column(:ctr, :header => "CTR") do |model|
    ('%.2f' % model.ctr_count).to_s + ' %' if model.views_count.to_i > 0
  end
  column(:campaign, html: true) do |model|
    link_to model.campaign_name, model.has_ads_group? ? index_campaign_group_stats_path(:campaign_id => model.campaign_id) : index_campaign_details_path(:campaign_id => model.campaign_id) if !model.campaign_id.nil?
  end
  column(:duration, :header => "Duration (days)") do |model|
    (model.campaign.expire_at - model.campaign.active_at + 1).to_i
  end
end
