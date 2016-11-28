class DeviceGroupTrackingsGrid
    include Datagrid

    scope do
      DeviceTracking
    end

    column(:no, html: true, order: false) do
      @row += 1
      @row
    end

    column(:dates, html:true) do |model|
      #link_to model.location.name, location_path(model.location)
      model.date_range
    end

    column(:ad_group, html:true) do |model|
      model.campaign_ads_group.nil? ? '' : model.campaign_ads_group.name
    end

    # column(:date, order: false)
    column(:views, :html => true) do |model|
      number_with_delimiter model.views
    end
    column(:number_of_device_ids, :html => true) do |model|
      number_with_delimiter model.number_of_device_ids
    end
    column(:device_ids_vs_views, :html => true) do |model|
      number_to_percentage (model.number_of_device_ids.to_f * 100 / model.views.to_f)
    end
    column(:frequency_cap, :html => true) do |model|
      number_with_delimiter model.frequency_cap
    end

    column(:actions, :html => true) do |model|
      render :partial => 'device_trackings/actions', :locals => {:model => model}
    end
  end