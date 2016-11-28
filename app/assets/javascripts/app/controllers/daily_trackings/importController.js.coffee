angular.module('dashboard')
  .controller('ImportController', [
    '$scope'
    ($scope) ->
      $scope.init = () ->

      $scope.onImportClick = (event) ->
        if angular.element('#daily_tracking_file').val() == ''
          event.preventDefault()
          return
  ])