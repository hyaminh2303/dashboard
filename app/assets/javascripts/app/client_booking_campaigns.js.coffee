#= require ./controllers/client_campaigns/clientCampaignController
# require ./directives/app_file_reader
#= require ./controllers/client_campaigns/stepsController
#= require ./controllers/client_campaigns/step1Controller
#= require ./controllers/client_campaigns/step2Controller
#= require ./controllers/client_campaigns/step3Controller
#= require ./controllers/client_campaigns/locationsController
#= require ./services/common
@clientCampaignApp = angular.module 'client_campaigns.app', ['ui.router', 'client_campaigns_index', 'client_campaigns_modifine', 'templates', 'rt.select2', 'ui.bootstrap', 'ng-file-model', 'ngFileUpload', 'ngCollection', 'collection.services', 'smart-table', 'ngSanitize', 'validator', 'validator.rules', 'leaflet-directive']
@clientCampaignApp.config ['$urlRouterProvider', '$stateProvider'
  ($urlRouterProvider, $stateProvider) ->
    config =
      rootName: 'client_campaigns'
    $stateProvider.state
      name: "client_campaigns"
      url: "/"
      templateUrl: '/client_booking_campaigns/list'
      controller: 'clientCampaignController'
      controllerAs: 'clientCampaignCtrl'
      data: config

    $stateProvider.state
      abstract: true
      name: "campaign_steps_new"
      url: "/new"
      templateUrl: '/client_booking_campaigns/steps'
      controller: 'stepsController'
      controllerAs: 'stepsCtrl'

    $stateProvider.state
      abstract: true
      name: "campaign_steps_edit"
      url: "/edit/:id"
      templateUrl: '/client_booking_campaigns/steps'
      controller: 'stepsController'
      controllerAs: 'stepsCtrl'

    for step in [1..3]
      $stateProvider.state
        name: "campaign_steps_new.step#{step}"
        url: ''
        templateUrl: "/client_booking_campaigns/step#{step}"
        controller: "step#{step}Controller"
        controllerAs: "step#{step}Ctrl"
        data: config

    for step in [1..3]
      $stateProvider.state
        name: "campaign_steps_edit.step#{step}"
        url: ''
        templateUrl: "/client_booking_campaigns/step#{step}"
        controller: "step#{step}Controller"
        controllerAs: "step#{step}Ctrl"
        data: config

    $urlRouterProvider.otherwise '/'

]
# @clientCampaignApp.config ['$httpProvider', ($httpProvider) ->
#   authToken = $("meta[name=\"csrf-token\"]").attr("content")
#   $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
# ]

