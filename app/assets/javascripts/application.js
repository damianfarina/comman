// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//= require chosen-jquery
//= require highcharts
//= require comman
//= require_tree .

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $( '.new-fields-container' ).append(content.replace(regexp, new_id));
  var afterAppendCallback = $( '.new-fields-container' ).data('afterAppend');
  if (afterAppendCallback != null)
    afterAppendCallback();
}

function remove_field(link) {
  $(link).parent().find( "input[type=hidden]" ).val("1");
  $(link).closest( "tr" ).fadeOut();
}