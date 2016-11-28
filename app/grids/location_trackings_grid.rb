class LocationTrackingsGrid
  include Datagrid

  scope do
    LocationTracking
  end

  column(:no, html: true, order: false) do
    @row += 1
    @row
  end

  column(:location_id, html:true) do |model|
    #link_to model.location.name, location_path(model.location)
    model.name
  end
  # column(:date, order: false)
  column(:views, :html => true) do |model|
    number_with_delimiter model.views
  end
  column(:clicks, :html => true) do |model|
    number_with_delimiter model.clicks
  end
  column(:created_at) do |model|
    model.created_at
  end

  column(:actions, :html => true) do |model|
    render :partial => 'location_trackings/actions', :locals => {:model => model}
  end
end