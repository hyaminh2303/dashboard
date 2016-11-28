angular.module('client_campaigns_modifine', []).controller "stepsController", [
  "$scope"
  "$http"
  "$state"
  ($scope, $http, $state) =>
    $scope.viewState = { totalImpressionAssessment: 0 }
    $scope.isSubmiting = false
    $scope.init = =>
      $scope.client_booking_campaign = {}
      if $scope.isEdit()
        $scope.getClientBookingCampaign()
      else
        $scope.client_booking_campaign = {
          banner_type: null,
          banner_size: [],
          description: null,
          no_specific_locations: null,
          campaign_name: null,
          advertiser_name: null,
          ad_tag: null,
          start_date: null,
          end_date: null,
          timezone: null,
          campaign_category: null,
          frequency_cap: null,
          campaign_type: null,
          target: null,
          unit_price: null,
          budget: null,
          country_code: null,
          time_schedule: null,
          carrier: null,
          wifi_or_cellular: null,
          os: null,
          app_category: null,
          additional: null,
          status: null,
          banners:[],
          places: []
        }
        $scope.booking_locations = []

    $scope.next = =>
      if $scope.viewState.step < 3
        nextStep = $scope.viewState.step + 1
        $scope.goTo(nextStep)
      else if $scope.viewState.step == 3
        $scope.isSubmiting = true
        if $scope.isEdit()
          $http.patch(Routes.client_booking_campaign_path($state.params.id, format: 'json'), $scope.client_booking_campaign).then (result) =>
            window.location = Routes.client_booking_campaigns_path()
        else
          $http.post(Routes.client_booking_campaigns_path(format: 'json'), $scope.client_booking_campaign).then (result) =>
            window.location = Routes.client_booking_campaigns_path()


    $scope.prev = ->
      if $scope.viewState.step > 1
        prevStep = $scope.viewState.step - 1
        $scope.goTo(prevStep)

    $scope.goTo = (step) ->
      if $scope.isEdit()
        $state.go("campaign_steps_edit.step#{step}")
      else
        $state.go("campaign_steps_new.step#{step}")

    $scope.activeStep = (step) ->
      if $scope.viewState.step == step then 'active' else ''

    $scope.isEdit = =>
      !!$state.params.id

    $scope.getClientBookingCampaign = =>
      campaign_id = $state.params.id
      $http.get(Routes.client_booking_campaign_path(campaign_id)).then (result) =>
        $scope.client_booking_campaign = result.data

    $scope.cancelCampaign = =>
      window.location = Routes.client_booking_campaigns_path()

    $scope.init()

]
