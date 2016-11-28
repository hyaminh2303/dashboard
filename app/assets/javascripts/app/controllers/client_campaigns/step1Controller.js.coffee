angular.module('client_campaigns_modifine').controller "step1Controller", [
  "$scope"
  "$http"
  "$state"
  "$modal"
  ($scope, $http, $state, $modal) =>
    $scope.init = ->
      $scope.viewState.step = 1
      $scope.viewState.nextButtonText = 'Next'

    $scope.banner_types = [
      {label: 'Standard image banner (jpg, gif)', key: 'standard'},
      {label: 'JS tag', key: 'ad_tag'},
      {label: 'Dynamic banner', key: 'dynamic_banner'}
    ]

    $http.get(Routes.list_banner_sizes_path(format: 'json')).then (result) =>
      $scope.banner_sizes = result.data

    $http.get(Routes.countries_path(format: 'json')).then (result) =>
      countries_list = []
      result.data.countries.map (c) =>
        countries_list.push({label: c[0], key: c[1].toLowerCase()})
      $scope.countries = countries_list

    # $scope.$watch ->
    #   $scope.client_booking_campaign
    # , (newValue, oldValue) ->
    #   console.log(newValue, oldValue)

    $scope.$watch ->
      $scope.client_booking_campaign.country_code
    , (newValue, oldValue) ->
      if newValue
        $scope.getCities()
        params = { country_code: newValue }
        places = $scope.getPlaceItems()
        if places.length > 0
          places.forEach (place) =>
            $scope.getImpressionAssessment(place)
        else
          $scope.calculateTotalImpressionWithoutPlaces()

    $scope.onCountryChange = =>
      $scope.client_booking_campaign.places = []

    $scope.getCities =  =>
      $http.get(Routes.load_in_country_densities_path(format: 'json'), {params: {country_code: $scope.client_booking_campaign.country_code}}).then (result) =>
        $scope.cities = result.data

    $scope.onCityChange = (place) =>
      $scope.getImpressionAssessment(place)

    $scope.onBannerSizeChange = () =>
      places = $scope.getPlaceItems()
      if places.length > 0
        places.forEach (place) =>
          $scope.getImpressionAssessment(place)
      else
        $scope.calculateTotalImpressionWithoutPlaces()

    $scope.addRow = () =>
      item = {
        city: '',
        impression_assessment: ''
        client_booking_locations_attributes: []
      }
      $scope.client_booking_campaign.places.push(item)
      $scope.getImpressionAssessment(item)

    $scope.removeRow = (item) =>
      item._destroy = true
      places = $scope.getPlaceItems()
      if places.length > 0
        $scope.calculateTotalImpression()
      else
        $scope.calculateTotalImpressionWithoutPlaces()

    $scope.getPlaceItems = =>
      _.filter $scope.client_booking_campaign.places, (item)-> !item._destroy?

    $scope.getImpressionAssessment = (place) =>
      params = { country_code: $scope.client_booking_campaign.country_code }
      params.city_name = place.city if place.city
      params['banner_size[]'] = $scope.client_booking_campaign.banner_size
      params['locations[]'] = place.client_booking_locations_attributes if place.city
      $http.get(Routes.calculate_impression_assessment_path(format: 'json'), params: params).then (result) =>
        place.impression_assessment = result.data.impression_assessment
        $scope.calculateTotalImpression()

    $scope.calculateTotalImpression = =>
      $scope.viewState.totalImpressionAssessment = 0
      $scope.getPlaceItems().forEach (p) =>
        $scope.viewState.totalImpressionAssessment += p.impression_assessment

    $scope.calculateTotalImpressionWithoutPlaces = =>
      params = { country_code: $scope.client_booking_campaign.country_code }
      params['banner_size[]'] = $scope.client_booking_campaign.banner_size
      $http.get(Routes.calculate_impression_assessment_path(format: 'json'), params: params).then (result) =>
        $scope.viewState.totalImpressionAssessment = result.data.impression_assessment

    $scope.addLocation = (lat, lng, radius, name, place) =>
      location =
        name: name
        radius: radius
        latitude: lat
        longitude: lng
      place.client_booking_locations_attributes.push location

    # $scope.isLocationNotExist = (lat, lng, index) =>
    #   if $scope.client_booking_campaign.places[index].client_booking_locations_attributes.length > 0
    #     return false if _.where($scope.client_booking_campaign.places[index].client_booking_locations_attributes, {latitude: lat, longitude: lng}).length
    #   return true

    $scope.readCSV = (files, place) =>
      csvfile = files[0]
      if !csvfile
        console.log("No CSV file selected.")
      else
        place.client_booking_locations_attributes.forEach (location) =>
          location._destroy = true
        $scope.readLatLngCSV(csvfile, place)

    $scope.readLatLngCSV = (csv, place) =>
      reader = new FileReader()
      reader.readAsText csv
      reader.onload = (event) =>
        csvData  = event.target.result
        lines    = csvData.split(/\n/)
        total    = lines.length-1
        quantity = 0
        loopNum = 0
        i = 1
        while i < lines.length
          currentline = lines[i].split(",")
          name   = currentline[0].replace(/"/g, '')
          lat    = currentline[1]
          lng    = currentline[2]
          radius = currentline[3]
          if lat != undefined && lng != undefined && radius != undefined && lat.trim() != "" && lng.trim() != "" && radius.trim() != ""
            # if $scope.isLocationNotExist(lat, lng, index)
            try
              $scope.addLocation(parseFloat(lat), parseFloat(lng), radius, name, place)
              console.log(quantity+" location(s) of "+total+" locations has been imported.") if loopNum == total
            catch e
          i++
        $scope.getImpressionAssessment(place)

    $scope.getPlaceLocations = (place) =>
      _.filter place.client_booking_locations_attributes, (item)-> !item._destroy?

    $scope.viewState.isValid = =>
      !!$scope.client_booking_campaign.banner_type && $scope.client_booking_campaign.banner_size && $scope.client_booking_campaign.country_code

    $scope.openModal = (place) =>
      $scope.selected_place = place
      $modal.open({
        templateUrl: '/client_booking_campaigns/step1_locations',
        controller: 'locationsCtrl',
        size: 'lg',
        scope: $scope
      })

    $scope.init()
]