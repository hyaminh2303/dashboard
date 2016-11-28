angular.module('dashboard').controller "VastGeneratorController", [
  "$scope"
  "$http"
  ($scope, $http) ->
    $scope.commitToS3 = ()->
      $('#commit_to_s3').val(1)
      $('#new_vast').submit()
      return
]