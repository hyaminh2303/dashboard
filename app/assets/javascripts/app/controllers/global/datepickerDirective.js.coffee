angular.module('dashboard')
  .directive('datepickerDirective', () ->
    restrict: 'A',
    require: '?ngModel',
    link: ($scope, element, attrs, ngModel) ->
      if ngModel
        element.datepicker(
          todayHighlight: true
          format: attrs.datepickerFormat
          startDate: new Date(parseInt(attrs.datepickerStartTime))
          endDate: new Date(parseInt(attrs.datepickerEndTime))
  ))
