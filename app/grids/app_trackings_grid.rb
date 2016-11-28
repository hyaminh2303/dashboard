class AppTrackingsGrid
  include Datagrid

  scope do
    AppTracking
  end
  column(:no, html: true, order: false) do
    @row += 1
    @row
  end
  column(:name, html:true) do |model|
    model.name
  end
  column(:views, :html => true) do |model|
    model.views == -1 ? '' : number_with_delimiter(model.views)
  end
  column(:clicks, :html => true) do |model|
    model.clicks == -1 ? '' : number_with_delimiter(model.clicks)
  end
  column(:created_at) do |model|
    model.created_at
  end
  column(:actions, :html => true) do |model|
    render :partial => 'app_trackings/actions', :locals => {:model => model}
  end
end
