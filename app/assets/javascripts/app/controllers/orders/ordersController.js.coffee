@app.controller("OrdersController", ["$scope", "$http", ($scope, $http) ->
  currentState = null
  $scope.agencyId = null
  $scope.saleManagerId = null
  getTableParams = (tableState) ->
    {
      start: tableState.pagination.start,
      limit: tableState.pagination.number,
      sort_by: tableState.sort.predicate,
      sort_dir: if tableState.sort.reverse then 'asc' else 'desc'
    }

  $scope.refresh = (tableState)->
    currentState = tableState
    params = getTableParams(tableState)

    params.agency_id = $scope.agencyId
    params.sale_manager_id = $scope.saleManagerId

    $http.get(Routes.orders_path(format: 'json'), params: params).then (result)->
      stats = result.data.stats
      $scope.rows = result.data.records
      tableState.pagination.numberOfPages = Math.round(stats.total / tableState.pagination.number)

  $http.get(Routes.agencies_path(format: 'json')).then (result) =>
    $scope.agencies = result.data.agencies

  $http.get(Routes.list_sale_managers_path(format: 'json')).then (result) =>
    $scope.managers = result.data.records

  $scope.remove = (order) ->
    result = confirm 'Do you want to delete this order ?'
    if result
      $http.delete(Routes.order_path(order.id, format: 'json')).then () =>
        $scope.refresh(currentState) if currentState

  $scope.searchOrder = () =>
    $scope.refresh(currentState) if currentState

  $scope.reset = () =>
    $scope.agencyId = null
    $scope.saleManagerId = null
    $scope.refresh(currentState) if currentState
    
])