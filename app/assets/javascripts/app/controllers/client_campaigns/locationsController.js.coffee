angular.module('client_campaigns_modifine').controller "locationsCtrl", [
  "$scope"
  "$http"
  "$state"
  "$modalInstance"
  "$rootScope"
  ($scope, $http, $state, $modalInstance, $rootScope) =>
    $scope.markers = []
    $scope.init = =>
      $scope.setCurrentMapview()
    $scope.ok = =>
      $modalInstance.close()

    $scope.cancel = =>
      $modalInstance.dismiss()

    $scope.addMarkersToMap = =>
      $scope.markers = []
      locations = $scope.validLocations()
      locations.forEach (location) =>
        $scope.markers.push({
          lat: location.position[0],
          lng: location.position[1],
          focus: true,
          draggable: true,
          icon: {
            iconUrl: '/images/marker-icon.png',
            iconSize: [25, 40],
            iconAnchor: [30, 40],
            popupAnchor: [0, 0],
            shadowSize: [0, 0],
            shadowAnchor: [0, 0]
          }
        })

    angular.extend $scope,
      paths:
        c1: {
          weight: 2,
          color: '#ff612f',
          latlngs: [1,1],
          radius: 10000,
          type: 'circle'
        }


    angular.extend $scope,
      center:
        lat: 1
        lng: 1
        zoom: 12
      events: {}
      layers:
        baselayers:
          osm:
            name: 'OpenStreetMap'
            url: 'https://{s}.tiles.mapbox.com/v3/examples.map-i875mjb7/{z}/{x}/{y}.png'
            type: 'xyz'
      defaults:
        scrollWheelZoom: true

    $scope.setCurrentMapview = =>
      $http.get(Routes.search_locations_client_booking_campaigns_path(format: 'json'), params: {city: $scope.$parent.selected_place.city}).then (result) =>
        data = result.data
        if data.length > 0
          # $scope.center = {
          #   lat: data[0].display_position.latitude,
          #   lng: data[0].display_position.longitude,
          #   zoom: 12
          # }
          $scope.center = {
            lat: 1,
            lng: 1,
            zoom: 12
          }

    $scope.searchLocation = =>
      url = 'https://places.cit.api.here.com/places/v1/autosuggest'
      params = {
        at: "#{$scope.center.lat},#{$scope.center.lng}",
        q: $scope.q,
        app_id: 'KYaQd4VGNJcMO8skLlub',
        app_code: 'S7gBMRTr-pqw0drZHCkxuQ',
        tf: 'plain',
        pretty: true
      }
      $http.get(url, params: params).then (resp) =>
        console.log(resp)
        $scope.search_results = resp.data.results
        $scope.addMarkersToMap()

    $scope.validLocations = =>
      _.filter($scope.search_results, (o) => !!o.position)

    $scope.init()
]