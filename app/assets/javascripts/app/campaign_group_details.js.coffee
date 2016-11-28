# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require ./controllers/global/popover
#= require_tree ./controllers/campaign_group_details
#= require_tree ./controllers/campaign_location_stats
#= require_tree ./controllers/campaign_os_stats
#= require_tree ./controllers/campaign_creative_stats
#= require_tree ./controllers/campaign_app_stats
#= require_tree ./controllers/campaign_device_stats

$(document).ready ->
  # Call initDataGrid one time only
  $('#campaign-nav-tab a[href="#location"]').on('shown.bs.tab', (e) ->
    angular.element($('#location .datatable-container')).scope().initDataGrid()
    $(this).unbind('shown.bs.tab')
  )
  $('#campaign-nav-tab a[href="#os"]').on('shown.bs.tab', (e) ->
    angular.element($('#os .datatable-container')).scope().initDataGrid()
    $(this).unbind('shown.bs.tab')
  )
  $('#campaign-nav-tab a[href="#creative"]').on('shown.bs.tab', (e) ->
    angular.element($('#creative .datatable-container')).scope().initDataGrid()
    $(this).unbind('shown.bs.tab')
  )
  $('#campaign-nav-tab a[href="#device"]').on('shown.bs.tab', (e) ->
    angular.element($('#device .datatable-container')).scope().initDataGrid()
    $(this).unbind('shown.bs.tab')
  )
  $('#campaign-nav-tab a[href="#app"]').on('shown.bs.tab', (e) ->
    angular.element($('#app .datatable-container')).scope().initDataGrid()
    $(this).unbind('shown.bs.tab')
  )
