Comman.namespace("business_delivery_notes");
Comman.business_delivery_notes.action_new = function() {

  var init = function() {
    setupAutocomplete();
    prepareItemDelete();
  }

  var prepareItemDelete = function() {
    $('#products_list').on('click', '.close.destroy', function(){
      var $tr = $(this).closest('tr');
      $tr.find('input[type=hidden].destroy').val('1');
      $tr.fadeOut();
      return false;
    });
  }

  var setupAutocomplete = function() {
    $( '#search_products.autocomplete' ).autocomplete({
      source: source = function( request, response ) {
        $.ajax({
          url: "/factory/products/autocomplete",
          dataType: "json",
          data: {
            term: request.term
          },
          success: function( data ) {
            response( data );
          }
        });
      },
      minLength: 2,
      select: function( event, ui ) {
        add_delivery_note_item(ui.item.id);
      }
    });
    $( '#search_clients.autocomplete' ).autocomplete({
      source: source = function( request, response ) {
        $.ajax({
          url: "/business/clients/autocomplete",
          dataType: "json",
          data: {
            term: request.term
          },
          success: function( data ) {
            response( data );
          }
        });
      },
      minLength: 2,
      select: function( event, ui ) {
        add_client(ui.item.id);
      }
    });
  }

  var add_delivery_note_item = function(product_id) {
    $.ajax({
      url: "/business/delivery_notes/delivery_note_item",
      data: { product_id: product_id },
      dataType: "html"
    }).done(function(msg){
      $('#products_list').find('tbody').append(msg);
      $('#search_products').val("");
    });
  }

  var add_client = function(client_id) {
    $.ajax({
      url: "/business/delivery_notes/client",
      data: { client_id: client_id },
      dataType: "html"
    }).done(function(msg){
      $('#client').html(msg);
      $('#search_clients').val("");
    });
  }
  return {
    init: init
  }
}();

Comman.business_delivery_notes.action_edit = Comman.business_delivery_notes.action_new;
Comman.business_delivery_notes.action_create = Comman.business_delivery_notes.action_new;
