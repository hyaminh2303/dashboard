angular.module('dashboard')
  .controller('UserCampaignGroupStatsController', [
    '$scope'
    ($scope) ->

      $scope.init = (campaign_id, date_format, agencyCanSeeDetailCampaign) ->
        $scope.agencyCanSeeDetailCampaign = agencyCanSeeDetailCampaign
        $scope.campaign_id = campaign_id
        $scope.initDataGrid(campaign_id)

        $scope.date_format = date_format

        return

      $scope.initDataGrid = (campaign_id) ->
        columns = [
            {
              data: 'group_name'
              render: (data, type, row, meta) ->
                return "<a href='#{Routes.detail_campaign_group_stats_path($scope.campaign_id, row.group_id)}'>#{data}</a>"
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
          ]

        if $scope.agencyCanSeeDetailCampaign
          columns.push({
            data: 'spend'
            orderable: false
          })

        columns.push({
          className: 'details-control'
          orderable: false
          data: null
          defaultContent: ''
        })
        table = $('#campaign-tracking-table').DataTable
          processing: true
          serverSide: true
          ajax: Routes.index_campaign_group_stats_path(campaign_id, {format: 'json'})
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          columns: columns
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

        tr.append($("<td>#{new Date(data.time * 1000).format($scope.date_format)}</td>"))
        tr.append($("<td>#{data.views}</td>"))
        tr.append($("<td>#{data.clicks}</td>"))
        tr.append($("<td>#{data.ctr}</td>"))
        if $scope.agencyCanSeeDetailCampaign
          tr.append($("<td>#{data.spend}</td>"))
        tr.append($("<td />"))

        return tr
  ])
