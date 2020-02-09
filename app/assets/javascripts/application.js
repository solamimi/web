// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
// require_tree .
//= require jquery
// require jquery_nested_form
//= require select2
//= require select2_locale_ja
// require jquery.remotipart
// require jquery.iframe-transport.js
//= require popper
//= require bootstrap
//= require material
// require bootstrap-datepicker/core
// require bootstrap-datepicker/locales/bootstrap-datepicker.ja
// require bootstrap-timepicker

$(document).on("turbolinks:before-cache", function() {
    $('.select2-input').select2('destroy');
});
$(document).on('turbolinks:load', function () {
  $('.select2').parents('.form-group').removeClass('label-floating');
  $('.select2').select2({
//    theme: "bootstrap"
  });
  $('input.datepicker').pickdate({
    format: 'yyyy/mm/dd',
    labelMonthNext: '翌月',
    labelMonthPrev: '先月',
    labelMonthSelect: '月',
    labelYearSelect: '年',
    monthsLong: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    weekdaysFull: ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    weekdaysShort: ['日', '月', '火', '水', '木', '金', '土'],
  });
  $('span.for-datepicker').on('click', function() {
    $(this).prev().focus();
  });
});

