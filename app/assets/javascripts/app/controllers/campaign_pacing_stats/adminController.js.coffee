angular.module('dashboard')
  .controller('AdminCampaignPacingStatsController', [
    '$scope'
    ($scope) ->

      $scope.init = (campaign_id, date_format) ->
        $scope.campaign_id = campaign_id
        $scope.initDataGrid(campaign_id)

        $scope.date_format = date_format

        return

      $scope.initDataGrid = (campaign_id) ->
        table = $('#campaign-pacing-table').DataTable
          processing: true
          serverSide: true
          ajax: Routes.index_campaign_pacing_health_stats_path(campaign_id, {format: 'json'})
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          columns: [
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
            {
              data: 'group_pacing'
              orderable: false
            }
            {
              data: 'group_health'
              orderable: false
            }
          ]
          searching: false
          fnRowCallback: (nRow, aData) -> 
            group_health = parseInt(aData.group_health.substring(0, aData.group_health.length - 1))

            if group_health < -5
              $(">td:eq(5)", nRow).addClass('health_level_1');
            else if group_health <= 5
              $(">td:eq(5)", nRow).addClass('health_level_2');
            else if group_health <= 10
              $(">td:eq(5)", nRow).addClass('health_level_3');
            else
              $(">td:eq(5)", nRow).addClass('health_level_4');

  ])
