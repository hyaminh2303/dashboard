# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./controllers/global
#= require_tree ./controllers/creative_trackings
$ ->
  $('#creative_trackings_report_type').change( ->
    redirectedUrl = $('#creative_trackings_report_type').val()
    if (redirectedUrl != Routes.campaign_creative_trackings_url)
      document.location.href = redirectedUrl
  )
  $('#creative_trackings_report_type').val(Routes.campaign_creative_trackings_url)
