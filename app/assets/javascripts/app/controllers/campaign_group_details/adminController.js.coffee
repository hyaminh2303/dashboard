angular.module('dashboard')
  .controller('AdminCampaignGroupDetailsController', [
    '$scope'
    ($scope) ->

      $scope.init = (campaign_id, group_id, date_format) ->
        $scope.campaign_id = campaign_id
        $scope.group_id = group_id

        if group_id == -1
          $scope.ajax_path = Routes.index_campaign_details_path(campaign_id, {format: 'json'})
        else
          $scope.ajax_path = Routes.detail_campaign_group_stats_path(campaign_id, group_id, {format: 'json'})

        $scope.date_format = date_format

        $scope.initDataGrid(campaign_id)

        return

      $scope.initDataGrid = (campaign_id) ->
        table = $('#campaign-tracking-table').DataTable
          processing: true
          serverSide: true
          ajax: $scope.ajax_path
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          columns: [
            {
              data: 'time'
              render: (data) ->
                return new Date(data * 1000).format($scope.date_format)
            }
            {
              data: 'views'
            }
            {
              data: 'clicks'
            }
            {
              data: 'ctr'
            }
            {
              data: 'spend'
            }
            {
              data: 'ecpm'
              orderable: false
            }
            {
              data: 'ecpc'
              orderable: false
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

        # Add event listener for opening and closing details
        $('#campaign-tracking-table tbody').on('click', 'td.details-control', () ->
          tr = $(this).closest('tr')
          row = table.row(tr)

          if tr.hasClass('shown')
            # This row is already open - close it
            $scope.hide(tr)
            tr.removeClass('shown')
          else
            # Open this row
            $scope.show(tr, row.data().data)
            tr.addClass('shown')
        )

      $scope.show = ($tr, data) ->
        for i in [data.length-1...-1]
          $tr.after($scope.format(data[i]))

      $scope.hide = ($tr) ->
        $tr.nextUntil('[role="row"]').remove()

      $scope.format = (data) ->
        tr = $('<tr class="sub" />')

        tr.append($("<td />"))
        tr.append($("<td>#{data.views}</td>"))
        tr.append($("<td>#{data.clicks}</td>"))
        tr.append($("<td>#{data.ctr}</td>"))
        tr.append($("<td>#{data.spend}</td>"))
        tr.append($("<td>#{data.ecpm}</td>"))
        tr.append($("<td>#{data.ecpc}</td>"))
        tr.append($("<td>#{data.platform}</td>"))

        return tr
  ])
