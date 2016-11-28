class CreativeTrackingsGrid
  include Datagrid

  scope do
    CreativeTracking
  end

  column(:no, html: true, order: false) do
    @row += 1
    @row
  end

  column(:creative, html:true) do |model|
    #link_to model.location.name, location_path(model.location)
    model.name
  end
  # column(:date, order: false)
  column(:impressions, :html => true) do |model|
    number_with_delimiter model.impressions
  end
  column(:clicks, :html => true) do |model|
    number_with_delimiter model.clicks
  end
  column(:unit_price) do |model|
    model.unit_price
  end
  column(:created_at) do |model|
    model.created_at
  end

  column(:actions, :html => true) do |model|
    render :partial => 'creative_trackings/actions', :locals => {:model => model}
  end
end