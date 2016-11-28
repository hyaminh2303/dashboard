module ApplicationHelper

  # Return a collapse/expand button on tools panel of a box
  # css_class: the additional CSS class, ex: btn-primary, btn-success, etc...
  def collapse_expand_button(css_class = 'btn-success')
    content_tag('button', '<i class="fa fa-minus"></i>'.html_safe,
                'data-widget' => 'collapse', class: "btn btn-xs #{css_class}", :title => I18n.translate('datagrid.header.tools.collapse_expand')
    )
  end

  # Return a remove button on tools panel of a box
  # css_class: the additional CSS class, ex: btn-primary, btn-success, etc...
  def remove_button(css_class = 'btn-success')
    content_tag('button', '<i class="fa fa-times"></i>'.html_safe,
                'data-widget' => 'remove', :class => "btn btn-xs #{css_class}", :title => I18n.translate('datagrid.header.tools.remove')
    )
  end

  def icon_tag(object_name = '')
    content_tag('i', '', :class => icon_class(object_name))
  end

  def icon_class(object_name = '')
    case object_name
      when :cog
        'fa fa-cog'
      when :dashboard
        'fa fa-dashboard'
      when :publisher
        'ion ion-speakerphone'
      when :advertiser
        'fa fa-rss'
      when :campaign
        'ion ion-ios7-browsers'
      when :order
        'ion ion-ios7-albums-outline'
      when :location
        'ion ion-beaker'
      when :location_lists
        'ion ion-help-circled'
      when :verified
        'ion ion-checkmark-circled'
      when :create
        'glyphicon glyphicon-plus'
      when :platform
        'ion ion-speakerphone'
      when :import
        'glyphicon glyphicon-import'
      when :currencies
        'fa fa-usd'
      when :roles
        'fa fa-shield'
      when :users
        'fa fa-user'
      when :vast
        'fa fa-file'
      when :export
        'glyphicon glyphicon-export'
      when :download
        'glyphicon glyphicon-download-alt'
      when :country_cost
        'fa fa-money'
      when :daily_est_imp
        'ion ion-stats-bars'
      when :banner_size
        'fa fa-arrows'
      when :setting
        'ion ion-settings'
      when :density
        'fa fa-group'
      when :list
        'fa fa-list'
      else
        ''
    end
  end

  def format_money(value)
    Money.new(value).format
  end

  def date_to_iso_string(date)
    date.strftime(Date::DATE_FORMATS[:iso])
  end

  def agency_can_see_detail_campaign?(current_user)
    current_user.agency_can_see_detail_campaign?.present?
  end

end
