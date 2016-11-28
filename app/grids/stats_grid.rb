class StatsGrid

  include Datagrid

  attr_accessor :current_ability
  attr_accessor :agency_can_see_detail_campaign

  scope do
    Campaign
  end

  self.default_column_options = {order: false}

  filter(:period_preset, :enum, default: 'last_7_days', select: Campaign::PERIODS.map {|k,v| [k.to_s.titleize, k]}, include_blank: 'Specific dates', html: {class: 'form-control select2-static'}) do |value|
  end

  filter(:period, :date, range: true, default: proc{[1.week.ago.to_date, Date.today]}) do |value|
    self.select_period(value)
  end

  column(:status, header: '', html: true) do |model|
    if model.has_attribute?(:active_at)
      content_tag('div', content_tag('i', nil, class: "ion-record #{model.status}"), class: 'pull-left')
    end
  end

  column(:name, :html => true) do |model|
    if model.has_attribute?(:name)
      values = [model.name, "#{model.active_at.to_formatted_s(:short_date)} - #{model.expire_at.to_formatted_s(:short_date)}"]
      render :partial => 'home/datagrid/cell_with_link.html.haml', locals: { campaign_id: model.id, has_ads_group: model.has_ads_group?, values: values, title: t('views.statss.tooltip.active_dates')}
    else
      t('views.statss.total')
    end
  end

  column(:views, :html => true) do |model|
    values = [number_with_delimiter(model.views), model.has_attribute?(:name) ? number_with_delimiter(model.target_impression) : nil]
    render :partial => 'home/datagrid/cell.html.haml', locals: {values: values, title: t('views.statss.tooltip.target_impression')}
  end

  column(:clicks, :html => true) do |model|
    values = [number_with_delimiter(model.clicks), model.has_attribute?(:name) ? number_with_delimiter(model.target_click) : nil]
    render :partial => 'home/datagrid/cell.html.haml', locals: {values: values, title: t('views.statss.tooltip.target_click')}
  end

  column(:ctr, header: I18n.t('views.statss.header.ctr'), :html => true) do |model|
    "#{model.ctr.round(2)}%"
  end

  column(:unit_price, header: 'Budget Spent', :html => true, if: proc{ |grid| grid.current_ability.can?(:manage, Campaign) || grid.agency_can_see_detail_campaign}) do |model|
    if model.has_attribute?(:name)
      values = [model.budget_spent.format, model.actual_budget.format]
    else
      values = [model.budget_spent.format, nil]
    end
    render :partial => 'home/datagrid/cell.html.haml', locals: {values: values, title: t('views.statss.tooltip.total_budget')}
  end

  column(:actions, header: '', :html => true, if: proc {|grid| grid.current_ability.can?(:create, Campaign) }) do |model|
    if model.has_attribute?(:name)
      render :partial => 'home/actions.html.haml', :locals => {:model => model}
    end
  end
end
