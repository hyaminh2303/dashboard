@app.controller("NewOrderController", ["$scope", "$http", ($scope, $http) ->
  $scope.order = {}
  $scope.init = (orderId, authorization) =>
    $scope.isEdit = orderId?
    if $scope.isEdit
      $scope.title = 'Edit IO'
      $http.get(Routes.order_path(orderId, format: 'json')).then (result) =>
        $scope.order = result.data 
        $scope.moneyIcon = $scope.order.billing_currency
        $scope.order.date =  new Date($scope.order.date)
        _.each $scope.order.order_items, (item) ->
          item.start_time = new Date(item.start_time)
          item.end_time = new Date(item.end_time)
    else
      $scope.title = 'Create new IO'
      $scope.order = {authorization: authorization}
      $scope.order.order_items = [
        {
          country: '',
          ad_format: '',
          banner_size: '',
          placement: '',
          start_time: new Date(),
          end_time: new Date(),
          rate_type: '',
          target_clicks_or_impressions: '',
          unit_cost: '',
          total_budget: ''
        }
      ]
      $scope.order.date =  new Date()
      $scope.order.currency_id = 1
      $scope.moneyIcon = 'USD'

    $http.get(Routes.list_sub_total_settings_path(format: 'json')).then (result) =>
      $scope.sub_total_settings = result.data.sub_total_settings
      if !$scope.isEdit
        $scope.order.sub_totals = []
        $scope.buildSubTotal()

  $scope.setBudgetPercent = (sub_total) =>
    sub_total.budget_percent = (_.find($scope.sub_total_settings, (s) ->
                                s.id == sub_total.sub_total_setting_id)).budget_percent

  $http.get(Routes.agencies_path(format: 'json')).then (result) =>
    $scope.agencies = result.data.agencies

  $http.get(Routes.list_currencies_path(format: 'json')).then (result) =>
    $scope.currencies = result.data.currencies

  $http.get(Routes.list_sale_managers_path(format: 'json')).then (result) =>
    $scope.managers = result.data.records

  $scope.options = {
    language: 'en',
    allowedContent: true,
    entities: false
  }

  $scope.rate_types = [{name: "CPC", value: "cpc"}, {name: "CPM", value: "cpm"}]

  $scope.sub_total_types = [{name: "Fixed", value: "fixed"}, {name: "Percent", value: "percent"}]
    
  $scope.addRow = () => 
    row = {
      country: '',
      ad_format: '',
      banner_size: '',
      placement: '',
      start_time: new Date(),
      end_time: new Date(),
      rate_type: '',
      target_clicks_or_impressions: '',
      unit_cost: '',
      total_budget: ''
    }
    $scope.order.order_items.push(row)

  $scope.removeRow = (item) => 
    item._destroy = true  
  
  $scope.addSubTotalRow = () =>
    row = {
            sub_total_setting_id: '',
            value: '',
          }
    $scope.order.sub_totals.push(row)

  $scope.removeSubTotalRow = (item) => 
    item._destroy = true

  $scope.setStartTimeEndTime = (item) =>
    if item.start_time > item.end_time
      item.end_time = item.start_time

  $scope.setMoneyIcon = () =>
    icon = _.find($scope.currencies, (s) ->
              s.id == $scope.order.currency_id)
    $scope.moneyIcon = icon.name

  $scope.getGrossBudget = () =>
    total = 0
    angular.forEach $scope.order.order_items, (item) =>
      if item.rate_type
        if item.rate_type == 'cpc'
          total += item.target_clicks_or_impressions * item.unit_cost
        else
          total += (item.target_clicks_or_impressions/1000) * item.unit_cost
    total

  $scope.getNetBudget = () =>
    total = $scope.getGrossBudget()
    angular.forEach $scope.getSubTotalItems(), (item) =>
      if item.sub_total_type == 'percent'
        total += (item.value * $scope.getGrossBudget())/100
      else
        total += item.value
    total

  $scope.submitOrder = () =>
    if $scope.isEdit
      $http.put(Routes.order_path($scope.order.id, format: 'json'), order: $scope.order).then (result) =>
        window.location = Routes.orders_path()
    else
      $http.post(Routes.orders_path(format: 'json'), order: $scope.order).then (result) =>
        window.location = Routes.orders_path()

  $scope.getOrderItems = =>
    _.filter $scope.order.order_items, (item)-> !item._destroy?

  $scope.getSubTotalItems = =>
    _.filter($scope.order.sub_totals, (item)-> !item._destroy? )

  $scope.caculateTotal = (item) =>
    return 0 if !item.rate_type
    if item.rate_type == 'cpc'
      item.target_clicks_or_impressions * item.unit_cost
    else
      (item.target_clicks_or_impressions/1000) * item.unit_cost

  $scope.buildSubTotal = =>
    angular.forEach $scope.sub_total_settings, (sub_total_setting) =>
      $scope.order.sub_totals.push({sub_total_setting_id: sub_total_setting.id, value: sub_total_setting.value, sub_total_type: sub_total_setting.sub_total_setting_type})

])