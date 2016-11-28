angular.module('dashboard').controller "IndexController", [
  "$scope"
  "$http"
  ($scope, $http) ->

    $stats_table = $('#stats_table')
    $period_preset = $('#stats_grid_period_preset')
    $start_date = $('.date_filter.from')
    $end_date = $('.date_filter.to')
    $date_filters = $('.date_filter')

    $btn_stats = $('.stats-buttons .btn')
    $btn_stats_views = $('.stats-buttons .btn_stat_views')
    $stats_table_tbody = $('#stats_table tbody')
    $alert_chart = $('#box-chart .alert')


    $scope.$stats_table_search = undefined
    $scope.oStatsTable = undefined

    $scope.campaign_name = 'Total'
    $scope.names = ['Views', 'Clicks', 'Budget Spent']
    $scope.actions = ['views', 'clicks', 'budget_spent']
    $scope.url = (data_type) ->
      Routes["#{$scope.actions[data_type]}_campaign_daily_trackings_path"]({campaign_id: $scope.campaign_id, format: 'json'})

    $scope.heat_url = ()->
      Routes.heat_campaign_location_trackings_path({campaign_id: $scope.campaign_id, format: 'json'})

    $scope.init = (is_agency, agencyCanSeeDetailCampaign)->
      $scope.is_agency = is_agency
      $scope.agencyCanSeeDetailCampaign = agencyCanSeeDetailCampaign
      $scope.initDataGrid()
      return

    $scope.loadRow = (data) ->
      $scope.campaign_id = if data.campaign_id == undefined then 0 else data.campaign_id
      $scope.campaign_name = if data.name == undefined then 'Total' else data.name
      $scope.views = data.views
      $scope.clicks = data.clicks
      $scope.budget = data.budget_spent
      $scope.loadChart()
      $btn_stats.removeClass('active');
      $btn_stats_views.addClass('active');

    $scope.clearStats = () ->
      $scope.campaign_id = 0
      $scope.campaign_name = 'Total'
      $scope.views = ''
      $scope.clicks = ''
      $scope.budget = ''
      chart.series[0].setData([])
      $scope.$apply()
      $btn_stats.addClass('disabled');

    $scope.loadChart = (data_type) ->
      chart.showLoading('<i class="fa fa-spinner fa-spin fa-2x"></i>')

      data_type |= 0

      #if add prefix $ to budget spent
      if data_type == 2
        chart.tooltip.valuePrefix = '$'
      else
        chart.tooltip.valuePrefix = ''

      #if search campaign by name, date filter is unlimited
      if $scope.$stats_table_search.val().length == 0
        params = {
          start_date: $start_date.val(),
          end_date  : $end_date.val(),
        }
      else
        params = {
          name_kw: $scope.$stats_table_search.val()
        }

      $http.get($scope.url(data_type), {params: params}).
      success((response) ->
        if response.category.length > 0
          $alert_chart.hide()
        else
          $alert_chart.show()

        data = []
        response.category.forEach((e,i)->
          data.push([e, response.data[i]])
        )
        chart.series[0].setData(data)
        chart.series[0].name = $scope.names[data_type]

        $scope.loadHeatMap()

        chart.hideLoading();
      )

    $scope.loadHeatMap = ()->
      params = {
        start_date: $start_date.val(),
        end_date  : $end_date.val(),
      }
      $http.get($scope.heat_url(), {params: params}).
        success((response) ->
          if response.length > 0
            $scope.$root.$broadcast('initHeatMap', {
              index:  0,
              types:  ['impression', 'click'],
              center: { "latitude": 10.7778527, "longitude": 106.69099 },
              zoom:   12,
              data:   response
            })
          else
            $scope.$root.$broadcast('flushHeatMap')
      )

    $scope.initDataGrid = ()->

      $scope.oStatsTable = $stats_table.DataTable(
        processing: true
        serverSide: true
        ajax: {
          type: 'POST'
          url: Routes.stats_path({format: 'json'}),
          data: (d)->
            prepareAjaxData(d)
        }
        bLengthChange: false
        columns: prepareTableColumns()
        language: {
          search: 'Search by Name'
        }

        preDrawCallback: (settings)->
          $('.loading').show()

        fnDrawCallback: ->
          drawCallback()

        fnInitComplete: (oSettings, json)->
          $stats_table.dataTable().fnSetFilteringDelay(1000)
      )

      return

    drawCallback = ()->
      $scope.$stats_table_search = $("#stats_table_filter input[type=search]")

      if $stats_table_tbody.find('tr[role=row]').length > 0
        $stats_table_tbody.find('tr:first-child').click()
        $btn_stats.removeClass('disabled');
      else
        $scope.clearStats()

      if $scope.$stats_table_search.val().length > 0
        date_range = [moment().subtract('year', 2).startOf('ioyear'), moment().add('year', 1).endOf('ioyear')]
        setDateFilter(date_range)
        $period_preset.select2('val','', true)

      $('.loading').hide()

      return

    prepareAjaxData = (data)->
      data.stats_grid ||= {}

      if $period_preset.val().length > 0
        data.stats_grid.period_preset = $period_preset.val()
      else
        data.stats_grid.period = [$start_date.val(), $end_date.val()]

      return

    prepareTableColumns = ()->
      columns = [
        {
          data: 'status'
          orderable: false
        }
        {
          data: 'name'
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
          data: 'unit_price'
          orderable: false
        })

      unless $scope.is_agency
        columns.push({
          data: 'actions'
          orderable: false
        })

      return columns

    $stats_table_tbody.on('click', 'tr[role=row]', ->
      $stats_table_tbody.find('tr').removeClass('selected')
      $(this).addClass('selected')
      $scope.loadRow($(this).data())
    )

    $period_preset.on('change', (e)->
      if(e.val.length > 0 )
        $date_filters.prop('disabled', true)
        $scope.oStatsTable.search('').draw()
      else
        $date_filters.prop('disabled', false)

      date_range = null;
      switch e.val
        when 'today' then date_range = [moment(), moment()]
        when 'yesterday' then date_range = [moment().subtract('days', 1), moment().subtract('days', 1)]
        when 'this_week' then date_range = date_range = [moment().startOf('isoweek'), moment().endOf('isoweek')]
        when 'last_week' then date_range = [moment().subtract('week', 1).startOf('isoweek'), moment().subtract('week', 1).endOf('isoweek')]
        when 'last_7_days' then date_range = [moment().subtract('days', 7), moment()]
        when 'this_month' then date_range = [moment().startOf('month'), moment().endOf('month')]
        when 'last_month' then date_range = [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]

      if(date_range)
        setDateFilter(date_range)

    )

    setDateFilter = (date_range)->
      $start_date.val(date_range[0].format('DD MMM YY'))
      $end_date.val(date_range[1].format('DD MMM YY'))

    $date_filters.datepicker({
      format: 'dd M yy'
    }).on('changeDate', (e)->
      $(this).doTimeout( 'date_filter', 1000, ()->
        start_date = $start_date.val()
        end_date = $end_date.val()

        if (start_date.length >0 && end_date.length >0)
          $scope.oStatsTable.search('').draw()
      )
    )

    if($period_preset.val().length)
      $date_filters.prop('disabled', true);

    $('.nav-tabs a').on('shown.bs.tab',(e)->
      $scope.$root.$broadcast('changeTypeHeatMap', {type: $(e.target).data("type")})
    )

    Highcharts.setOptions global:
      useUTC: false

    chart_options =
      chart:
        renderTo: "stats_chart"
        height: 250
        zoomType: "x"
        marginTop: 5
        marginBottom: 20

      title: false
      xAxis:
        type: "datetime"
        dateTimeLabelFormats:
          second: "%H:%M:%S"
          minute: "%H:%M"
          hour: "%H:%M"
          day: "%e %b"
          month: "%e %b"
          year: "%b"

        minTickInterval: 24 * 3600 * 1000

      yAxis:
        title: false
        plotLines: [
          value: 0
          width: 1
          color: "#808080"
        ]

      tooltip:
        useHTML: true
        valuePrefix: ""
        formatter: ->
          "<p>" + @series.chart.tooltip.valuePrefix + @y.toLocaleString() + "</p><p>" + @series.name + "</p><p>" + (new Date(@x)).toString("d MMM") + "</p>"

      legend: false
      series: [
        type: "area"
        color: "#1a96d3"
        name: "Views"
        data: []
      ]
      credits: false
      plotOptions:
        area:
          fillColor:
            linearGradient:
              x1: 1
              y1: 0
              x2: 0
              y2: 1

            stops: [
              [
                0
                Highcharts.getOptions().colors[0]
              ]
              [
                1
                Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get("rgba")
              ]
            ]

    chart = new Highcharts.Chart(chart_options)
]




