Comman.namespace("factory_making_orders");
Comman.factory_making_orders = function() {
  var options = {};

  var setupAutocomplete = function() {
    $( '.autocomplete' ).autocomplete({
      source: source = function( request, response ) {
        $.ajax({
          url: options.source,
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
        add_order_item(ui.item.id);
      }
    });
  }

  var add_order_item = function(product_id) {
    $.ajax({
      url: "/factory/making_orders/making_order_item",
      data: { product_id: product_id },
      dataType: "html"
    }).done(function(msg){
      $('#products_list').find('tbody').append(msg);
      $('#search-products').val("");
    });
  }

  return {
    options: options,
    setupAutocomplete: setupAutocomplete
  }
}();

Comman.factory_making_orders.action_edit = function() {
  var init = function() {
    Comman.factory_making_orders.setupAutocomplete();
    $('#products_list').on('click', '.close.destroy', function(){
      var $tr = $(this).closest('tr');
      $tr.find('input[type=hidden].destroy').val('1');
      $tr.fadeOut();
      return false;
    });
  }

  return {
    init: init
  }
}();

Comman.factory_making_orders.action_show = function() {
  var init = function() {

    $('.print-btn').on('click', function() {
      window.print();
    });
  }

  return {
    init: init
  }
}();

Comman.factory_making_orders.action_create = Comman.factory_making_orders.action_edit;
Comman.factory_making_orders.action_update = Comman.factory_making_orders.action_edit;
Comman.factory_making_orders.action_new = Comman.factory_making_orders.action_edit;
