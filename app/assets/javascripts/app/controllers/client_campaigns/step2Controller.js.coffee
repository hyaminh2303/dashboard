angular.module('client_campaigns_modifine').controller "step2Controller", [
  "$scope"
  "$http"
  ($scope, $http) ->
    $scope.init = ->
      $scope.viewState.step = 2
      $scope.viewState.nextButtonText = 'Next'
      $scope.categories = []
      $scope.fetchAppCategories()

    $scope.campaign_types = [
      {label: 'CPM', key: 'cpm'},
      {label: 'CPC', key: 'cpc'}
    ]

    $scope.wifi_or_cellulars = [
      {label: 'Any', key: 'any'},
      {label: 'Wifi', key: 'wifi'},
      {label: 'Mobile', key: 'mobile'}
    ]

    $scope.operating_systems = [
      {label: 'Any', key: 'any'},
      {label: 'Android', key: 'android'},
      {label: 'IOs', key: 'ios'}
    ]

    $scope.fetchAppCategories = =>
      $http.get(Routes.app_categories_path(format: 'json')).then (result) =>
        $scope.categories = result.data

    $scope.calculateBudget = =>
      if $scope.client_booking_campaign.campaign_type == 'cpc'
        $scope.client_booking_campaign.budget = $scope.client_booking_campaign.target * $scope.client_booking_campaign.unit_price
      else if $scope.client_booking_campaign.campaign_type == 'cpm'
        $scope.client_booking_campaign.budget = ($scope.client_booking_campaign.target / 1000) * $scope.client_booking_campaign.unit_price

    $scope.viewState.isValid = =>
      if $scope.client_booking_campaign.end_date || $scope.client_booking_campaign.start_date
        isValidDate = moment($scope.client_booking_campaign.end_date).startOf('day') >= moment($scope.client_booking_campaign.start_date).startOf('day')
      else
        isValidDate = true

      isValidDate && $scope.isValidBudget()

    $scope.isValidTarget = =>
      $scope.client_booking_campaign.target <= $scope.viewState.totalImpressionAssessment

    $scope.isValidBudget = =>
      if $scope.calculateBudget()
        $scope.calculateBudget() >= 1000
      else
        true

    $scope.getTargetLabel = =>
      if $scope.client_booking_campaign.campaign_type == 'cpm'
        'Target impression'
      else
        'Target click'

    $scope.dateOptions = {
      minDate: moment(new Date())
    }

    $scope.init()
]
