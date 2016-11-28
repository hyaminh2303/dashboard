// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.api.fnSetFilteringDelay
//= require bootstrap.min
//= require select2
//= require admin-lte
//= require bootstrap-datetimepicker/core
//= require bootstrap-datetimepicker/pickers
//= require bootstrap-datepicker
//= require angular
//= require angular-animate
//= require angular-ui-bootstrap-tpls
//= require angular-resource
//= require angular-collection
//= require angular-ui-router
//= require angular-rails-templates
//= require angular-sanitize.min
//= require ng-file-upload-all.min
//= require angular-validator
//= require angular-validator-rules
//= require angularjs/rails/resource
//= require leaflet
//= require angular-leaflet-directive
//= require array
//= require ng-file-model
//= require js-routes
//= require lodash
//= require date
//= require date/extras
//= require smart-table
//= require angular-select2
//= require moment
//= require angular-datepicker
//= require ckeditor-jquery
//= require ckeditor/config
//= require angular-ckeditor
//= require app/app
//= require bootstrap.file-input
//= require dotimeout
//= require leaflet
//= require_self

var ready = function () {
    $(".select2-static").select2();
    //Flat red color scheme for iCheck
    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
        checkboxClass: 'icheckbox_flat-red',
        radioClass: 'iradio_flat-red'
    });
    $(".select2-tags").select2({tags:[], separator: "'"});

    $('.btn-file-input').bootstrapFileInput();

    $("body").tooltip({ selector: '[data-toggle=tooltip]' });
};
$(document).ready(ready);
