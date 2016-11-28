# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require_self
#= require_tree ./controllers/vast

$ ->
  $('#vast_file').change( ->
    if($(this).val().length > 0)
      $('.box-loading .loading').show()
      $('#new_vast').submit()
  )

  $('[type=submit]').click( ->
    $('.box-loading .loading').show()
  )

  $('#vast_has_companion_ad').on('ifUnchecked', ->
    $('#companion-ad').find('.form-control').prop('disabled', true).parents('.panel').hide()
  ).on('ifChecked', ->
    $('#companion-ad').collapse('show').find('.form-control').prop('disabled', false).parents('.panel').show()
  )

  $('.vast_creative_type input').on('ifChecked', ->
    switch $(this).val()
      when 'preroll'
        show_panel('#preroll-ad')
        hide_panel('#overlay-ad')
      when 'overlay'
        show_panel('#overlay-ad')
        hide_panel('#preroll-ad')
  )

  hide_panel = (name)->
    $("#{name} .form-control").prop('disabled', true).parents('.panel').hide()

  show_panel = (name)->
    $(name).collapse('show').find('.form-control').prop('disabled', false).parents('.panel').show()
