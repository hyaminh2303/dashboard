# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./controllers/global
#= require_tree ./controllers/app_trackings
$ ->
  $('#app_trackings_report_type').change( ->
    redirectedUrl = $('#app_trackings_report_type').val()
    document.location.href = redirectedUrl

  )

