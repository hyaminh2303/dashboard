angular.module('dashboard')
  .controller('UserCampaignDeviceStatsController', [
    '$scope'
    ($scope) ->
      $scope.init = (campaign_id, ads_group_hidden, agencyCanSeeDetailCampaign) ->
        $scope.campaign_id = campaign_id
        $scope.current_row_number = 1
        $scope.ads_group_hidden = ads_group_hidden
        $scope.agencyCanSeeDetailCampaign = agencyCanSeeDetailCampaign
        return

      $scope.initDataGrid = () ->
        if $scope.ads_group_hidden == true
          columns = [
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

          if $scope.agencyCanSeeDetailCampaign
            columns.push({
              data: 'spend'
              orderable: false
            })

          $('#campaign-device-table').DataTable
            processing: true
            serverSide: true
            ajax: Routes.index_campaign_device_stats_path($scope.campaign_id, {format: 'json'})
            autoWidth: false
            lengthMenu: [ 15, 30, 50, 75, 100 ]
            preDrawCallback: (settings) ->
              $scope.current_row_number = settings._iDisplayStart + 1
            columns: columns
            order: [[1, 'asc']]
            searching: false
        else
          columns = [
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

          if $scope.agencyCanSeeDetailCampaign
            columns.push({
              data: 'spend'
              orderable: false
            })

          $('#campaign-device-table').DataTable
            processing: true
            serverSide: true
            ajax: Routes.index_campaign_device_stats_path($scope.campaign_id, {format: 'json'})
            autoWidth: false
            lengthMenu: [ 15, 30, 50, 75, 100 ]
            preDrawCallback: (settings) ->
              $scope.current_row_number = settings._iDisplayStart + 1
            columns: columns
            order: [[1, 'asc']]
            searching: false
  ])
