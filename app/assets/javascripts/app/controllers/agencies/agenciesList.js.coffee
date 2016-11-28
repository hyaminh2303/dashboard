angular.module('dashboard').controller "AgenciesListController", [
  '$scope',
  '$http',
  '$compile'
  ($scope, $http, $compile) ->
    $scope.init = () ->
      $scope.table = $('#agencies-list-table').DataTable
        processing: true
        serverSide: true
        ajax:
          url: Routes.list_agencies_path()
          data: (d) ->
            d.filter = {
              name: $scope.search_name if $scope.search_name != ''
              email: $scope.search_email if $scope.search_email != ''
              country_code: $scope.search_country_code if $scope.search_country_code != ''
            }
            return d
        autoWidth: false
        lengthMenu: [ 15, 30, 50, 75, 100 ]
        columns: [
          {
            data: 'name'
            render: (name, type, row, meta) ->
              "<a href='#{Routes.agency_path(row.id)}'>#{name}</a>"
          }
          {
            data: 'country'
          }
          {
            data: 'email'
            render: (email) ->
              "<a href='mailto:#{email}'>#{email}</a>"
          }
          {
            data: 'hide_finance'
            className: 'text-center'
            orderable: false
            render: (hide_finance, type, row) ->
              ''
          }
          {
            data: 'enabled'
            className: 'text-center'
            orderable: false
            render: (enabled, type, row) ->
              $scope.getEnabledHtml(enabled, row.id)
          }
          {
            className: 'actions'
            orderable: false
            render: (_null_, type, row) ->
              $scope.action_buttons(row)
          }
          {
            className: 'details-control'
            orderable: false
            data: null
            defaultContent: ''
          }
        ]
        order: [[0, 'asc']]
        searching: false
        createdRow: (row, data, index) ->
          if data.clients.length > 0
            $row = $(row)
            $row.attr('id', "agency_#{data.id}")
            $row.addClass('has-expand-rows')
            $row.find('.details-control').attr('ng-click', 'onExpandRow($event)')
        drawCallback: () ->
          $scope.compile($('#agencies-list-table').get(0))

      return

    $scope.onSearch = () ->
      $scope.table.ajax.reload(null, true)

    $scope.onReset = () ->
      $scope.search_name = ''
      $scope.search_email = ''
      $scope.search_country_code = ''
      $('.agencies_form_country_code .select2-chosen').text('')
      $scope.table.ajax.reload(null, true)

    $scope.getEnabledHtml = (enabled, id) ->
      if enabled
        "<a href='' ng-click='onDisable($event, #{id})' title='Enabled - Click to disable' class='text-green'><i class='ion-checkmark-circled' /></a>"
      else
        "<a href='' ng-click='onEnable($event, #{id})' title='Disabled - Click to enable' class='text-red'><i class='ion-close-circled' /></a>"

    $scope.getHideFinanceHtml = (hideFinance, id) ->
      if !hideFinance
        "<a href='' ng-click='onHideFinance($event, #{id})' title='Show finance - Click to hide finance' class='text-green'><i class='ion-checkmark-circled' /></a>"
      else
        "<a href='' ng-click='onShowFinance($event, #{id})' title='Hide finance - Click to show finance' class='text-red'><i class='ion-close-circled' /></a>"

    $scope.onEnable = ($event, id) ->
      $scope.enable(true, $event.target, id, Routes.enable_agency_path)
      return

    $scope.onDisable = ($event, id) ->
      $scope.enable(false, $event.target, id, Routes.disable_agency_path)
      return

    $scope.enable = (enabled, target, id, route) ->
      $target = $(target)

      # Set enabled of client to `enabled' var
      $tr = $target.closest('tr')
      child_index = parseInt($tr.data('child-index'))
      unless isNaN(child_index)
        parent_id = $tr.data('parent-id')
        parent = $scope.table.row($("#agency_#{parent_id}").get(0)).data()
        parent.clients[child_index].enabled = enabled

      html = $($scope.getEnabledHtml(enabled, id))
      $target.closest('td').empty().append(html)
      $scope.compile(html.get(0))
      $http.post route(id)

    $scope.onHideFinance = ($event, id) ->
      $scope.hideFinance(true, $event.target, id, Routes.hide_finance_agency_path)
      return

    $scope.onShowFinance = ($event, id) ->
      $scope.hideFinance(false, $event.target, id, Routes.show_finance_agency_path)
      return

    $scope.hideFinance = (hideFinance, target, id, route) ->
      $target = $(target)

      $tr = $target.closest('tr')
      child_index = parseInt($tr.data('child-index'))
      unless isNaN(child_index)
        parent_id = $tr.data('parent-id')
        parent = $scope.table.row($("#agency_#{parent_id}").get(0)).data()
        parent.clients[child_index].hide_finance = hideFinance

      html = $($scope.getHideFinanceHtml(hideFinance, id))
      $target.closest('td').empty().append(html)
      $scope.compile(html.get(0))
      $http.post route(id)

    $scope.onExpandRow = ($event) ->
      tr = $($event.target).closest('tr')
      row = $scope.table.row(tr)

      if tr.hasClass('shown')
        # This row is already open - close it
        $scope.hide(tr)
        tr.removeClass('shown')
      else
        # Open this row
        $scope.show(tr, row.data().clients, tr.hasClass('odd'))
        tr.addClass('shown')

      return

    $scope.show = ($tr, data, is_odd) ->
      for i in [data.length-1...-1]
        $newTr = $scope.format(data[i], i, is_odd)
        $tr.after($newTr)
        $scope.compile($newTr.get(0))

    $scope.hide = ($tr) ->
      $tr.nextUntil('[role="row"]').remove()

    $scope.format = (data, child_index, is_odd) ->
      tr = $("<tr class='sub' data-child-index='#{child_index}' data-parent-id='#{data.parent_id}' />")

      tr.addClass('odd') if is_odd

      tr.append($("<td><a href='#{Routes.agency_path(data.id)}'>#{data.name}</a></td>"))
      tr.append($("<td>#{data.country}</td>"))
      tr.append($("<td><a href='mailto:#{data.email}'>#{data.email}</a></td>"))
      tr.append($("<td class='text-center'>#{$scope.getHideFinanceHtml(data.hide_finance, data.id)}</td>"))
      tr.append($("<td class='text-center'>#{$scope.getEnabledHtml(data.enabled, data.id)}</td>"))
      tr.append($("<td>#{$scope.action_buttons(data)}</td>"))
      tr.append($("<td />"))

      return tr

    $scope.action_buttons = (model) ->
      $div = $("<div><div class='btn-group pull-right'>" +
        "<button class='btn btn-default btn-xs dropdown-toggle' type='button' data-toggle='dropdown'>" +
          "<span class='glyphicon glyphicon-cog'></span>" +
          "<span class='sr-only'>Toggle Dropdown</span>" +
        "</button>" +
        "<ul class='dropdown-menu' role='menu'>" +
        "</ul>" +
        "</div></div>")

      $dropdown = $div.find('.dropdown-menu')

      $dropdown.append("<li><a href='#{Routes.new_agency_path(selected: model.id)}'><i class='glyphicon glyphicon-plus'></i>Add New Client</a></li>") unless model.parent_id

      $dropdown.append("<li><a href='#{Routes.send_invitation_agency_path(model.id)}' method='post' data-method='post' data-confirm='Are you sure you want to send an invitation email?'><i class='glyphicon glyphicon-envelope'></i>Send an invitation email</a></li>") if model.enabled

      $dropdown.append("<li><a href='#{Routes.agency_path(model.id)}'><i class='glyphicon glyphicon-eye-open'></i>View Details</a></li>")
      $dropdown.append("<li><a href='#{Routes.edit_agency_path(model.id)}'><i class='glyphicon glyphicon-pencil'></i>Edit</a></li>")
      $dropdown.append("<li><a href='#{Routes.agency_path(model.id)}' method='delete' data-method='delete' data-confirm='Are you sure you want to delete the Agency \"#{model.name}\" permanently?'><i class='glyphicon glyphicon-remove'></i>Delete</a></li>")

      $dropdown.append("<li><a href='#{Routes.reset_password_agency_path(model.id)}' method='post' data-method='post' data-confirm='Are you sure you want to reset Agency \"#{model.email}\" password?'><i class='glyphicon glyphicon-user'></i>Reset Agency password</a></li>") if model.enabled
      $dropdown.append("<li><a href='#{Routes.become_agency_path(model.id)}' method='post' data-method='post' data-confirm='Are you sure you want to log in as Agency \"#{model.email}\"?'><i class='glyphicon glyphicon-log-in'></i>Log in as this Agency</a></li>")

      $div.html()

    $scope.compile = (element) ->
      $compile(element)($scope)
]
