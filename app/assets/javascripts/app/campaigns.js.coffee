# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./controllers/campaigns

ready = =>
  $('#campaign_target_per_ad_group').on 'ifChecked', (e)->
    if !$('#campaign_has_ads_group').is(':checked')
      $('#campaign_has_ads_group').iCheck('check'); 
  
  $('#campaign_has_ads_group').on 'ifUnchecked', (e)->
    $('#campaign_target_per_ad_group').iCheck('uncheck'); 

$(document).ready(ready);

