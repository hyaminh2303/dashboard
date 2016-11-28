angular.module('client_campaigns_index', ['smart-table']).controller "clientCampaignController", [
  "$scope"
  "$http"
  "$state"
  ($scope, $http, $state) =>
    currentState = null
    $scope.init = =>
      $scope.client_booking_campaigns = []
      $scope.message = false

    $scope.deleteCampaign = (campaign_id) =>
      if confirm('Are you sure?')
        $http.delete(Routes.client_booking_campaign_path(campaign_id, format: 'json')).then (result) =>
          $scope.message = result.data.notice
          $scope.refresh(currentState) if currentState
      else
        console.log('++++++')

    $scope.closeAlert = =>
      $scope.message = false

    $scope.approveCampaign = (campaign_id) =>
      $scope.updateStatus(campaign_id, 'approved')

    $scope.closeCampaign = (campaign_id) =>
      $scope.updateStatus(campaign_id, 'closed')

    $scope.updateStatus = (campaign_id, status) =>
      if confirm('Are you sure?')
        $http.post(Routes.update_status_client_booking_campaign_path(campaign_id, format: 'json', status: status)).then (result) =>
          $scope.message = result.data.notice
          $scope.refresh(currentState) if currentState
      else
        console.log('++++++')

    $scope.isDisplayApproveLink = (campaign) =>
      if campaign.status == 'closed' || campaign.status == 'waiting_for_approval' then true else false

    $scope.isDisplayCloseLink = (campaign) =>
      if campaign.status == 'approved' || campaign.status == 'waiting_for_approval' then true else false


    $scope.getStatusText = (campaign) =>
      switch campaign.status
        when 'approved'
          return '<i class="fa fa-check-circle approved-campaign" title="Approved"></i>'
        when 'closed'
          return '<i class="fa fa-circle closed-campaign" title="Closed"></i>'
        else
          return '<i class="fa fa-exclamation-circle waiting-campaign" title="Waiting for approval"></i>'

    $scope.searchCampaign = =>
      $scope.refresh(currentState) if currentState

    $scope.resetCampaignFilter = =>
      $scope.campaign_name = ''
      $scope.advertiser_name = ''
      $scope.status = ''
      $scope.refresh(currentState) if currentState


    getTableParams = (tableState) ->
      {
        sort_by: tableState.sort.predicate,
        sort_dir: if tableState.sort.reverse then 'asc' else 'desc'
      }

    $scope.refresh = (tableState)->
      currentState = tableState
      params = getTableParams(tableState)

      params.campaign_name = $scope.campaign_name
      params.advertiser_name = $scope.advertiser_name
      params.status = $scope.status

      $http.get(Routes.client_booking_campaigns_path(format: 'json'), params: params).then (result) =>
        $scope.client_booking_campaigns = result.data.campaigns
        $scope.statuses = result.data.statuses
        # tableState.pagination.numberOfPages = Math.round(stats.total / tableState.pagination.number)

    $scope.init()
]