@app = angular.module('dashboard', ['smart-table', 'rt.select2', 'ui.bootstrap', 'ckeditor', 'ui.router', 'templates'])

Math.round_two = (value) ->
  Math.round(value * 100) / 100
