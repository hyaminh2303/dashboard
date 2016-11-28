angular.module('dashboard')
  .controller('AdminCampaignDeviceStatsController', [
    '$scope'
    ($scope) ->
      $scope.init = (campaign_id, ads_group_hidden) ->
        $scope.campaign_id = campaign_id
        $scope.current_row_number = 1
        $scope.ads_group_hidden = ads_group_hidden
        return

      $scope.initDataGrid = () ->
        if $scope.ads_group_hidden == true
          $('#campaign-device-table').DataTable
            processing: true
            serverSide: true
            ajax: Routes.index_campaign_device_stats_path($scope.campaign_id, {format: 'json'})
            autoWidth: false
            lengthMenu: [ 15, 30, 50, 75, 100 ]
            preDrawCallback: (settings) ->
              $scope.current_row_number = settings._iDisplayStart + 1
            columns: [
              {
                data: null
                orderable: false
                width: '5%'
                render: ->
                  $scope.current_row_number++
              }
              {
                data: 'date_range'
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
                data: 'number_of_device_ids'
              }
              {
                data: 'device_ids_vs_views'
              }
              {
                data: 'frequency_cap'
              }

            ]
            order: [[1, 'asc']]
            searching: false
        else
          $('#campaign-device-table').DataTable
            processing: true
            serverSide: true
            ajax: Routes.index_campaign_device_stats_path($scope.campaign_id, {format: 'json'})
            autoWidth: false
            lengthMenu: [ 15, 30, 50, 75, 100 ]
            preDrawCallback: (settings) ->
              $scope.current_row_number = settings._iDisplayStart + 1
            columns: [
              {
                data: null
                orderable: false
                width: '5%'
                render: ->
                  $scope.current_row_number++
              }
              {
                data: 'date_range'
              }
              {
                data: 'group_ads_name'
              }
              {
                data: 'views'
              }
              {
                data: 'clicks'
              }
              {
                data: 'ctr'
                orderable: false
              }
              {
                data: 'number_of_device_ids'
              }
              {
                data: 'device_ids_vs_views'
              }
              {
                data: 'frequency_cap'
              }

            ]
            order: [[1, 'asc']]
            searching: false
  ])
