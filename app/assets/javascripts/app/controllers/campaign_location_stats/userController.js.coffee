angular.module('dashboard')
  .controller('UserCampaignLocationStatsController', [
    '$scope'
    ($scope) ->

      $scope.init = (campaign_id, agencyCanSeeDetailCampaign) ->
        $scope.campaign_id = campaign_id
        $scope.current_row_number = 1
        $scope.agencyCanSeeDetailCampaign = agencyCanSeeDetailCampaign

        return

      $scope.initDataGrid = () ->
        columns = [
          {
            data: null
            orderable: false
            width: '5%'
            render: ->
              $scope.current_row_number++
          }
          {
            data: 'location_name'
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

        $('#campaign-location-table').DataTable
          processing: true
          serverSide: true
          ajax: Routes.index_campaign_location_stats_path($scope.campaign_id, {format: 'json'})
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          preDrawCallback: (settings) ->
            $scope.current_row_number = settings._iDisplayStart + 1
          columns: columns
          order: [[1, 'asc']]
          searching: false
  ])
