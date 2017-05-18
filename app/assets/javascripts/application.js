// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

document.addEventListener("turbolinks:load", function() {
  setupLinkToResource();
});

function setupLinkToResource() {
  $('[data-form-prepend]').click( function(e) {
    var obj = $( $(this).attr('data-form-prepend') );
    obj.find('input, select, textarea').each( function() {
      $(this).attr( 'name', function() {
        return $(this).attr('name').replace( 'new_record', (new Date()).getTime() );
      });
    });
    obj.insertBefore( this );
    return false;
  });
}
