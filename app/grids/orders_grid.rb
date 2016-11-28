class OrdersGrid

  include Datagrid

  scope do
    Order
  end

  filter(:campaign_id, :enum , select: proc{Campaign.all.map{|m| [m.name, m.id]}}, include_blank: true, html: {class: 'form-control select2-static'})
  filter(:advertiser_id, :enum , select: proc{Advertiser.all.map{|m| [m.name, m.id]}}, include_blank: true, html: {class: 'form-control select2-static'})
  filter(:created_at, :date, :range => true)

  column(:name)
  column(:campaign_id, html:true) do |model|
    link_to model.campaign.name, campaign_path(model.campaign)
  end
  column(:publisher_id, html: true) do |model|
    link_to model.publisher.name, publisher_path(model.publisher)
  end
  column(:status, :html => true, :class => 'text-center') do |model|
    case model.status
      when Order::STATUS_PUBLISHED
        link_to content_tag('i', '', :class => 'ion-checkmark-circled').html_safe,
                expire_order_path(model), :method => :post, :class => 'text-green', :title => 'Published - Click to expire'
      when Order::STATUS_EXPIRED
        link_to content_tag('i', '', :class => 'ion-close-circled').html_safe,
                publish_order_path(model), :method => :post, :class => 'text-red', :title => 'Expired - Click to republish'
      else
        link_to content_tag('i', '', :class => 'ion-help-circled').html_safe,
                publish_order_path(model), :method => :post, :class => 'text-blue', :title => 'Pending - Click to publish'
    end
  end
  column(:created_at) do |model|
    model.created_at.to_date
  end

  column(:actions, :html => true) do |model|
    render :partial => 'orders/actions', :locals => {:model => model}
  end
end
