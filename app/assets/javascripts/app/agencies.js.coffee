# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_tree ./controllers/agencies

ready = =>
  setState $('#agency_use_contact_info').is(':checked')

  $('#agency_use_contact_info').on 'ifToggled', (e)->
    if e.currentTarget.checked
      setState true
      coppyValue $('#agency_contact_name'), $('#agency_billing_name')
      coppyValue $('#agency_contact_phone'), $('#agency_billing_phone')
      coppyValue $('#agency_contact_email'), $('#agency_billing_email')
      coppyValue $('#agency_contact_address'), $('#agency_billing_address')
    else
      setState false
    
  $('#agency_contact_name').keyup ->
    checkState $('#agency_contact_name'), $('#agency_billing_name')

  $('#agency_contact_phone').keyup ->
    checkState $('#agency_contact_phone'), $('#agency_billing_phone')

  $('#agency_contact_email').keyup ->
    checkState $('#agency_contact_email'), $('#agency_billing_email')

  $('#agency_contact_address').keyup ->
    checkState $('#agency_contact_address'), $('#agency_billing_address')

  $('#agency_phone').keydown (e) ->
    checkPhoneNumber e

  $('#agency_billing_phone').keydown (e) ->
    checkPhoneNumber e

  checkPhoneNumber = (e) ->
    return if $.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 189]) isnt -1 or (e.keyCode is 65 and e.ctrlKey is true) or (e.keyCode is 67 and e.ctrlKey is true) or (e.keyCode is 88 and e.ctrlKey is true) or (e.keyCode >= 35 and e.keyCode <= 39) or (e.keyCode is 48 and e.shiftKey) or (e.keyCode is 57 and e.shiftKey) or (e.keyCode is 187 and e.shiftKey)
    e.preventDefault()  if (e.shiftKey or (e.keyCode < 48 or e.keyCode > 57)) and (e.keyCode < 96 or e.keyCode > 105)

  checkState = (from, to) ->
    if $('#agency_use_contact_info').is(':checked')
      coppyValue from, to

  coppyValue = (from, to) ->
    to.val(from.val())

$(document).ready(ready);

setState = (state) ->
  $('#agency_billing_name').prop('readonly', state);
  $('#agency_billing_phone').prop('readonly', state);
  $('#agency_billing_email').prop('readonly', state);
  $('#agency_billing_address').prop('readonly', state);