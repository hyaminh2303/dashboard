angular.module('dashboard', ['smart-table'])
.controller("SaleManagerController", ["$scope", "$http", ($scope, $http) ->

  currentState = null
  itemsByPage  = 20 
  $scope.query = {}

  $scope.refresh = (tableState)->
    currentState = tableState
    params = getTableParams(tableState)

    $http.get(Routes.sale_managers_path(format: 'json'), params: params).then (result)->
      $scope.rows = result.data.records
      result.data.count = 0 if result.data.count < itemsByPage
      tableState.pagination.numberOfPages = Math.round(result.data.count / tableState.pagination.number)

  $scope.getTemplate = (model) =>
    index = $scope.rows.indexOf(model)
    if index % 2 == 0
      "eventRow"
    else
      "oddRow"

  $scope.search = =>
    $scope.refresh(currentState)

  $scope.reset = =>
    $scope.query = {}
    $scope.refresh(currentState)

  $scope.onDelete = (id) =>
    result = confirm 'Do you want to delete this sale manager ?'
    if result
      $http.delete(Routes.sale_manager_path(id)).then (result)->
        isDeleted = result.data.is_deleted
        if isDeleted
          $scope.refresh(currentState) if currentState
        else
          alert("This sale manager cannot be deleted!")

  getTableParams = (tableState) ->
    { 
      name:  $scope.query.name
      phone: $scope.query.phone
      email: $scope.query.email
      address: $scope.query.address
      start: tableState.pagination.start,
      limit: tableState.pagination.number,
      sort_by: tableState.sort.predicate,
      sort_dir: if tableState.sort.reverse then 'asc' else 'desc'
    }
])