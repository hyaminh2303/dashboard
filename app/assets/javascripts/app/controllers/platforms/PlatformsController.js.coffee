angular.module('dashboard', ['datePicker', 'smart-table', 'highcharts-ng', 'rt.select2'])
.controller("PlatformsController", ["$scope", "$http", ($scope, $http) ->
  $scope.startDate = moment()
  $scope.endDate = moment()
  $scope.period = 'last_7_days'
  $scope.selectedPlatform = {}
  $scope.dates = {}
  $scope.chartTab = 'views'

  currentState = null

  getTableParams = (tableState) ->
    {
      start: tableState.pagination.start,
      limit: tableState.pagination.number,
      sort_by: tableState.sort.predicate,
      sort_dir: if tableState.sort.reverse then 'asc' else 'desc'
    }

  $scope.periods = [
    {name: 'Specific Date', value: 'custom'},
    {name: 'Today', value: 'today'},
    {name: 'Yesterday', value: 'yesterday'}
    {name: 'This Week', value: 'this_week'}
    {name: 'Last Week', value: 'last_week'}
    {name: 'Last 7 days', value: 'last_7_days'}
    {name: 'This Month', value: 'this_month'}
    {name: 'Last Month', value: 'last_month'}
  ]

  $scope.$watch ->
    $scope.period
  , (value)->
    dateRange = null
    $scope.enableDatePicker = false
    switch value
      when 'today' then dateRange = [moment(), moment()]
      when 'yesterday' then dateRange = [moment().subtract('days', 1), moment().subtract('days', 1)]
      when 'this_week' then dateRange = [moment().startOf('isoweek'), moment().endOf('isoweek')]
      when 'last_week' then dateRange = [moment().subtract('week', 1).startOf('isoweek'), moment().subtract('week', 1).endOf('isoweek')]
      when 'last_7_days' then dateRange = [moment().subtract('days', 7), moment()]
      when 'this_month' then dateRange = [moment().startOf('month'), moment().endOf('month')]
      when 'last_month' then dateRange = [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]

    if dateRange
      $scope.dates.startDate = dateRange[0].format('DD MMM YYYY')
      $scope.dates.endDate = dateRange[1].format('DD MMM YYYY')
      refreshAll()

  $scope.onDateChanged = ->
    refreshAll()

  $scope.onPlatformSelected = ->
    selectedRow = _.findWhere $scope.rows, {isSelected: true}
    return if $scope.selectedPlatform == selectedRow
    $scope.selectedPlatform = selectedRow
    $scope.loadChart('views')
    $scope.chartStats = { views: selectedRow.views, clicks: selectedRow.clicks, budget_spent: selectedRow.budget_spent }

  $scope.refresh = (tableState)->
    currentState = tableState
    params = getTableParams(tableState)
    params.from = getDate($scope.dates.startDate)
    params.to = getDate($scope.dates.endDate)

    $http.get('/platforms.json', params: params).then (result)->
      stats = result.data.stats
      $scope.rows = result.data.records
      console.log($scope.rows)
      totalRow = { name: 'Total', views: stats.views, clicks: stats.clicks, budget_spent: stats.budget_spent }
      $scope.rows.splice(0, 0, totalRow)
      $scope.chartStats = stats
      tableState.pagination.numberOfPages = Math.round(stats.total / tableState.pagination.number)

  $scope.clearSelection = ->
    $scope.selectedPlatform = null
    $scope.loadChart('views')

  $scope.chartConfig =
    options:
      chart:
        type: 'line'
      legend:
        enabled: false
      xAxis:
        type: 'datetime'
      yAxis:
        title:
          text: ''
    series: []
    title:
      text: ''

  $scope.isShowChart = true
  $scope.loadChart = (field)->
    $('.loading').show()
    $scope.chartTab = field
    params = { field: field, from: getDate($scope.dates.startDate), to: getDate($scope.dates.endDate) }
    params.platform_id = $scope.selectedPlatform.id if $scope.selectedPlatform.id

    $http.get("/platforms/stats", params: params).then (result)->
      $scope.chartConfig.series = [{ color: "#1a96d3", name: field, type: "area", data: result.data }]
      $scope.isShowAlert = result.data.length == 0
      $('.loading').hide()
    , ->
      $('.loading').hide()

  refreshAll = =>
    $scope.refresh(currentState) if currentState
    $scope.loadChart('views')

  $scope.remove = (platform) ->
    result = confirm 'Do you want to delete this platform ?'
    if result
      $http.delete("/platforms/#{platform.id}").then ->
        refreshAll()

  getDate = (date)->
    moment(date).format('YYYY-MM-DD')
])