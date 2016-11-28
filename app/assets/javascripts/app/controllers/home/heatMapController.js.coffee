angular.module('dashboard')
.controller("HeatMapController", [
  "$scope"
  "$http"
  ($scope, $http)->
    $scope.map = $(".heat-map-map")
    $scope.playButtonIcon = $("#play-button i")
    $scope.date = $("#heat-map-date")
    $scope.day = $("#heat-map-day")
    $scope.bar = $(".heat-map-progress .progress-bar")
    $scope.zoom_intensity = $("#heat-map-panel .slider")
    $scope.heat_map_panel = $("#heat-map-panel")
    $scope.alert = $("#heat-map .alert")
    $scope.play_controller = $("#play-controller")

    $scope.init = (e, args)->
      $scope.index = args.index
      $scope.types = args.types
      $scope.center = args.center
      $scope.zoom = $scope.zoom || args.zoom
      $scope.data = args.data
      $scope.prepare()
      $scope.render()

    $scope.prepare = ->
      $scope.type     = $scope.type || "impression"
      $scope.playing  = false
      $scope.days     = $scope.data.length
      $scope.index    = 0 if $scope.index < 0 or $scope.index > ($scope.days - 1)
      $scope.gradient = [
        'rgba(0, 255, 255, 0)',
        'rgba(0, 255, 255, 1)',
        'rgba(0, 191, 255, 1)',
        'rgba(0, 127, 255, 1)',
        'rgba(0, 63, 255, 1)',
        'rgba(0, 0, 255, 1)',
        'rgba(0, 0, 223, 1)',
        'rgba(0, 0, 191, 1)',
        'rgba(0, 0, 159, 1)',
        'rgba(0, 0, 127, 1)',
        'rgba(63, 0, 91, 1)',
        'rgba(127, 0, 63, 1)',
        'rgba(191, 0, 31, 1)',
        'rgba(255, 0, 0, 1)'
      ]

    $scope.render = ->
      if $scope.data && $scope.data.length > 0
        $scope.renderMap()
        $scope.update()
      else
        $scope.flush()

    $scope.renderMap = ->
      if $scope.gmap != undefined 
        $scope.gmap.remove()
      $scope.gmap = L.map($scope.map[0]).setView([51.505, -0.09], 13)
      L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoib3BzIiwiYSI6ImNpbW9vZHljZTAwanN1YWx5cm8wdnJwb2EifQ.ZWAJLsaF0-B3sjWkgfOflA",
        maxZoom: 18
        attribution: "Yoose"
        id: "mapbox.streets"
      ).addTo $scope.gmap

      $scope.gmap.on "zoomend", (e) ->
        $scope.zoom = $scope.gmap.getZoom()
      $scope.heat_map_panel.css('visibility', 'visible')
      $scope.play_controller.css('visibility', 'visible')

    $scope.checkIndexBounds = ->
      $scope.index = 0 if $scope.index >= $scope.days
      $scope.index = $scope.days - 1 if $scope.index < 0

    $scope.update = ->
      $scope.gmap.removeLayer($scope.heatmap) if $scope.heatmap != undefined
      $scope.alert.hide()
      $scope.checkIndexBounds()
      data      = []
      data_heat = []
      min_intensity = max_intensity = 0
      max_position = undefined
      positions = $scope.data[$scope.index].types[$scope.type]
      min_intensity = positions[0][2] if (positions.length > 0)
      for position in positions
        min_intensity = position[2] if (position[2] < min_intensity and position[2] > 0)
        if position[2] > max_intensity
          max_intensity = position[2]
          max_position = L.latLng(position[0], position[1])
        data.push { location: L.latLng(position[0], position[1]), weight: position[2] }
        a = [position[0], position[1], position[2], position[2]]
        data_heat.push a

      for child in data_heat
        a = Math.round(child[2]/max_intensity * 100)
        a = 10 if a <= 10
        child[2] = a

      $scope.zoom_intensity.remove()

      $scope.gmap.on "click", (e) ->
        for ltln in data_heat
          if Math.round(ltln[0]*1000)/1000 == Math.round(e.latlng.lat*1000)/1000 && Math.round(ltln[1]*1000)/1000 == Math.round(e.latlng.lng*1000)/1000
            popup = L.popup()
            if $scope.type == 'impression'
              mess = $scope.format(ltln[3]) + " impressions."
            else
              mess = $scope.format(ltln[3]) + " clicked."
            popup.setLatLng(e.latlng).setContent(mess).openOn $scope.gmap
            return
      $scope.gmap.panTo max_position if max_position
      try
        $scope.heatmap  = L.heatLayer(data_heat,
          radius: 12, 
          maxZoom: 18
        ).addTo $scope.gmap
      catch

      $scope.bar.css("width", "#{($scope.index + 1) * (100/$scope.days)}%")
      $scope.day.html "Day #{$scope.index + 1}"
      if $scope.data.length > 0
        $scope.date.html "#{$scope.pad($scope.data[$scope.index].year)}-#{$scope.pad($scope.data[$scope.index].month)}-#{$scope.pad($scope.data[$scope.index].day)}"

    $scope.flush = ()->
      $scope.alert.show()
      $scope.map.html('').css('background-color', 'white')
      $scope.heat_map_panel.css('visibility', 'hidden')
      $scope.play_controller.css('visibility', 'hidden')
      $scope.data = []

    $scope.changeType = (type_map) ->
      $scope.type = type_map
      if $scope.type
        $scope.render()
      return

    $scope.selectDay = (e) ->
      $scope.index = parseInt($(e.target).data("index"))
      $scope.update()
      return

    $scope.selectNextDay = () ->
      $scope.index += 1
      $scope.update()
      return

    $scope.format = (num) ->
      num += ""
      x = num.split(".")
      x1 = x[0]
      x2 = (if x.length > 1 then "." + x[1] else "")
      rgx = /(\d+)(\d{3})/
      x1 = x1.replace(rgx, "$1" + "," + "$2")  while rgx.test(x1)
      x1 + x2

    $scope.selectPreviousDay = () ->
      $scope.index -= 1
      $scope.update()
      return

    $scope.step = ->
      $scope.index += 1
      if $scope.index < $scope.days
        $scope.index = $scope.days - 1 if $scope.index < 0
  
        $scope.update()
  
        if $scope.index < $scope.days-1
          setTimeout ( -> $scope.step() if $scope.playing), 2000
        else
          $scope.playing = false
          $scope.playButtonIcon.removeClass("glyphicon-pause").addClass("glyphicon-play")

    $scope.pad = (number) ->
      return number if number > 9
      return "0#{number}"

    $scope.playOrStop = () ->
      $scope.playing = not $scope.playing
      $scope.playButtonIcon.removeClass("glyphicon-pause").addClass("glyphicon-play") if not $scope.playing
      $scope.playButtonIcon.removeClass("glyphicon-play").addClass("glyphicon-pause") if $scope.playing
      $scope.index = -1 if $scope.index >= $scope.days - 1
      $scope.step() if $scope.playing
      return

    $scope.restart = ()->
      $scope.playing = true
      $scope.playButtonIcon.removeClass("glyphicon-play").addClass("glyphicon-pause")
      $scope.index = -1
      $scope.step()
      return

    $scope.$on('initHeatMap', (e, args)->
        $scope.init(e, args)
      )

    $scope.$on('changeTypeHeatMap', (e, args)->
      $scope.changeType(args.type)
    )

    $scope.$on('flushHeatMap', ()->
      $scope.flush()
    )
])
.directive('ngSlide', ()->
  (scope, element, attrs) ->
    element.bind('slide', (e)->
      scope.zoomIntensity(e)
    )
)