angular.module('dashboard')
.controller('UserCampaignGroupDetailsController', [
    '$scope'
    ($scope) ->

      $scope.init = (campaign_id, group_id, date_format, agencyCanSeeDetailCampaign) ->
        $scope.campaign_id = campaign_id
        $scope.group_id = group_id
        $scope.agencyCanSeeDetailCampaign = agencyCanSeeDetailCampaign

        if group_id == -1
          $scope.ajax_path = Routes.index_campaign_details_path(campaign_id, {format: 'json'})
        else
          $scope.ajax_path = Routes.detail_campaign_group_stats_path(campaign_id, group_id, {format: 'json'})

        $scope.date_format = date_format

        $scope.initDataGrid(campaign_id)

        return

      $scope.initDataGrid = (campaign_id) ->
        columns = [
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
        ]

        if $scope.agencyCanSeeDetailCampaign
          columns.push({
            data: 'spend'
            orderable: false
          })

        $('#campaign-tracking-table').DataTable
          processing: true
          serverSide: true
          ajax: $scope.ajax_path
          autoWidth: false
          lengthMenu: [ 15, 30, 50, 75, 100 ]
          columns: columns
          order: [[0, 'asc']]
          searching: false
  ])