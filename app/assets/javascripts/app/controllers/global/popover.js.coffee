angular.module('dashboard')
  .controller('PopoverController', [
    '$scope'
    ($scope) ->
      $scope.init = (selector) ->
        angular.element(selector).popover
          container: 'body'
          trigger: 'hover'
          placement: 'auto'
        return
  ])