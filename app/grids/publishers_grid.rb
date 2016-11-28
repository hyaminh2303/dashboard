class PublishersGrid

  include Datagrid

  scope do
    Publisher
  end

  filter(:created_at, :date, :range => true)

  column(:name)
  column(:email)
  column(:status, :html => true, :class => 'text-center') do |model|
    case model.status
      when Publisher::STATUS_PUBLISHED
        link_to content_tag('i', '', :class => 'ion-checkmark-circled').html_safe,
                expire_publisher_path(model), :method => :post, :class => 'text-green', :title => 'Published - Click to expire'
      when Publisher::STATUS_EXPIRED
        link_to content_tag('i', '', :class => 'ion-close-circled').html_safe,
                publish_publisher_path(model), :method => :post, :class => 'text-red', :title => 'Expired - Click to republish'
      else
        link_to content_tag('i', '', :class => 'ion-help-circled').html_safe,
                publish_publisher_path(model), :method => :post, :class => 'text-blue', :title => 'Pending - Click to publish'
    end
  end
  column(:created_at) do |model|
    model.created_at.to_date
  end

  column(:actions, :html => true) do |model|
    render :partial => 'publishers/actions', :locals => {:model => model}
  end
end
