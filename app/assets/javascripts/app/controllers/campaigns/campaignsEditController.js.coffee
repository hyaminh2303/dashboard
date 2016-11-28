angular.module('dashboard').controller "EditController", [
  "$scope"
  "$http"
  ($scope, $http) ->
    $scope.url = Routes.actual_budget_campaigns_path({format: 'json'})

    $scope.init = (price, currency, campaign_type, target_impression, target_click, exchange_rate, discount, bonus_impression, development_fee) ->
      $scope.price = price
      $scope.currency = currency
      $scope.campaign_type = campaign_type
      $scope.target_impression = target_impression
      $scope.target_click = target_click
      $scope.exchange_rate = exchange_rate
      $scope.discount = discount
      $scope.bonus_impression = bonus_impression
      $scope.development_fee = development_fee
      $scope.market_exchange_rate = '0.5'
      $scope.update()
      return

    $scope.update = ->
      $http.post($scope.url, {
        price: $scope.price
        currency: $scope.currency
        campaign_type: $scope.campaign_type
        target_impression: $scope.target_impression
        target_click: $scope.target_click
        exchange_rate: $scope.exchange_rate
        discount: $scope.discount
        bonus_impression: $scope.bonus_impression
        development_fee: $scope.development_fee
      }).success((data, status, headers, config) ->
        $scope.market_exchange_rate = data.market_exchange_rate
        $scope.usd = data.unit_price_in_usd
        $scope.budget = data.budget
        $scope.actual_budget = data.actual_budget
      )
]
