Comman.namespace("business_delivery_notes");
Comman.business_delivery_notes.action_new = function() {

  var init = function() {
    setupAutocomplete();
  }

  var setupAutocomplete = function() {
    $( '.autocomplete' ).autocomplete({
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
  }

  var add_delivery_note_item = function(product_id) {
    $.ajax({
      url: "/business/delivery_notes/delivery_note_item",
      data: { product_id: product_id },
      dataType: "html"
    }).done(function(msg){
      $('#products_list').find('tbody').append(msg);
      $('#search-products').val("");
    });
  }
  return {
    init: init
  }
}();

Comman.business_delivery_notes.action_edit = Comman.business_delivery_notes.action_new;