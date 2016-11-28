# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  navigation.renderer = TreeViewRenderer

  # Specify the class that will be applied to active navigation items.
  # Defaults to 'selected' navigation.selected_class = 'your_selected_class'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = 'treeview_active'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  # navigation.consider_item_names_as_safe = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.dom_class = 'sidebar-menu'

    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>if: -> { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>unless: -> { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #

    primary.item :dashboard, 'Dashboard', root_path, icon: icon_class(:dashboard)

    primary.item :campaigns, I18n.t('views.navigation.campaigns.index'), campaigns_path, icon: icon_class(:campaign)
    primary.item :platforms, I18n.translate('views.navigation.platforms.index'), platforms_path, icon: icon_class(:platform), if: -> { current_ability.can?(:list, Platform) }
    primary.item :agencies, I18n.t('views.navigation.agencies.index'), agencies_path, icon: icon_class(:dashboard), if: -> { current_ability.can?(:list, Agency) }
    #primary.item :advertisers, I18n.t('views.navigation.advertisers.index'), advertisers_path, :icon => icon_class(:advertiser)
    #primary.item :publishers, I18n.t('views.navigation.publishers.index'), publishers_path, :icon => icon_class(:publisher)
    primary.item :orders, I18n.t('views.navigation.orders.index'), orders_path, :icon => icon_class(:order) if current_user.super_admin? || current_user.admin?
    primary.item :locations, I18n.t('views.navigation.locations.index'), locations_path, :icon => icon_class(:location), if: -> { current_ability.can?(:list, Location) }
    #primary.item :location_lists, I18n.t('views.navigation.location_lists.index'), location_lists_path, :icon => icon_class(:location_lists)
    primary.item :currencies, I18n.t('views.navigation.currencies.index'), currencies_path, icon: icon_class(:currencies), if: -> { current_ability.can?(:list, Currency) }
    primary.item :users, I18n.t('views.navigation.users.index'), users_path, icon: icon_class(:users), if: -> { current_ability.can?(:list, User) }
    primary.item :roles, I18n.t('views.navigation.roles.index'), roles_path, icon: icon_class(:roles), if: -> { current_ability.can?(:list, Role) }
    primary.item :vast_generator, I18n.t('views.navigation.vast_generator.index'), vast_generator_path, icon: icon_class(:vast), if: -> { current_ability.can?(:index, Vast) }
    primary.item :client_booking_campaigns, 'Request Campaigns', client_booking_campaigns_path, icon: icon_class(:list)

    primary.item :setting, I18n.t('views.navigation.settings.index'), '#', class: 'treeview', icon: icon_class(:setting) do |setting|
      setting.dom_class = 'treeview-menu'
      setting.item :banner_size, I18n.t('views.navigation.banner_sizes.index'), banner_sizes_path, icon: icon_class(:banner_size)
      setting.item :country_cost, I18n.t('views.navigation.country_costs.index'), country_costs_path, icon: icon_class(:country_cost)
      setting.item :daily_est_imps, I18n.t('views.navigation.daily_est_imps.index'), daily_est_imps_path, icon: icon_class(:daily_est_imp)
      setting.item :density, I18n.t('views.navigation.density.index'), densities_path, icon: icon_class(:density)
      setting.item :settings, I18n.t('views.navigation.io_setting.index'), order_settings_path, icon: icon_class(:cog), if: -> { current_ability.can?(:manage, OrderSetting) }
    end


    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, class: 'special', if: -> { current_user.admin? }
    # primary.item :key_4, 'Account', url, unless: -> { logged_in? }

    # you can also specify html attributes to attach to this particular level
    # works for all levels of the menu
    # primary.dom_attributes = {id: 'menu-id', class: 'menu-class'}

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false
  end
end
