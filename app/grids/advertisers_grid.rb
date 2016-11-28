class AdvertisersGrid

  include Datagrid

  scope do
    Advertiser
  end

  filter(:name, :string)

  column(:name)
  column(:contact)
  column(:email)
  column(:status, :html => true, :class => 'text-center') do |model|
    case model.status
      when Advertiser::STATUS_PUBLISHED
        link_to content_tag('i', '', :class => 'ion-checkmark-circled').html_safe,
                expire_advertiser_path(model), :method => :post, :class => 'text-green', :title => 'Published - Click to expire'
      when Advertiser::STATUS_EXPIRED
        link_to content_tag('i', '', :class => 'ion-close-circled').html_safe,
                publish_advertiser_path(model), :method => :post, :class => 'text-red', :title => 'Expired - Click to republish'
      else
        link_to content_tag('i', '', :class => 'ion-help-circled').html_safe,
                publish_advertiser_path(model), :method => :post, :class => 'text-blue', :title => 'Pending - Click to publish'
    end
  end
  column(:created_at) do |model|
    model.created_at.to_date
  end

  column(:actions, :html => true) do |model|
    render :partial => 'advertisers/actions', :locals => {:model => model}
  end
end
