angular.module('dashboard')
  .controller('CampaignAppNoDataStatsController', [
    '$scope'
    ($scope) ->
      $scope.init = (campaign_id) ->
        $scope.campaign_id = campaign_id
        $scope.current_row_number = 1
        $scope.type_column = []
        return

      $scope.initDataGrid = () ->
        $('#campaign-app-table').DataTable
          processing: true
          serverSide: true
          ajax: Routes.index_campaign_app_stats_path($scope.campaign_id, {format: 'json'})
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          preDrawCallback: (settings) ->
            $scope.current_row_number = settings._iDisplayStart + 1
          columns:    [
            {
              data: null
              orderable: false
              width: '5%'
              render: ->
                $scope.current_row_number++
            }
            {
              data: 'app_name'
            }
          ]
          order: [[1, 'asc']]
          searching: false
  ])
