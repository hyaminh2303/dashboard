angular.module('dashboard')
  .controller('DatepickerChangeController', [
    '$scope'
    ($scope) ->
      $scope.init = (input_selector, selected_time, format, path) ->
        $scope.date = new Date(selected_time).toString(format)
        $scope.format = format
        $scope.path = path
        $scope.$input = $(input_selector)
        return

      $scope.onChangeDate = () ->
        if $scope.$input.is(':focus')
          # when user are inputting, reload event
          return

        if ($scope.date == '')
          return

        window.location = "#{$scope.path}?date=#{$scope.date}"
        return

      $scope.onBlur = (event) ->
        if $scope.$input.attr('value') != $scope.date
          $scope.onChangeDate()
  ])
