class OsTrackingsGrid
  include Datagrid

  scope do
    OsTracking
  end

  column(:no, html: true, order: false) do
    @row += 1
    @row
  end

  column(:operating_system_id, html:true) do |model|
    model.operating_system.name
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
    render :partial => 'os_trackings/actions', :locals => {:model => model}
  end
end