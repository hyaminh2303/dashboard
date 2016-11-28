angular.module('dashboard')
.controller('ImportController', [
    '$scope'
    ($scope) ->
      $scope.init = (confirm_msg) ->
        $scope.confirm_msg = confirm_msg

      $scope.onImportClick = (event) ->
        if (angular.element('#device_trackings_file').val() == '') || ($scope.confirm_msg != '' && !confirm($scope.confirm_msg))
          event.preventDefault()
          return
  ])
