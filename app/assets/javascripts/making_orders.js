Comman.namespace("factory_making_orders");
Comman.factory_making_orders = function() {
  var options = {};

  var setupAutocomplete = function() {
    $( '.autocomplete' ).autocomplete({
      source: Comman.factory_making_orders.options.source,
      minLength: 2,
      select: function( event, ui ) {
        var $input = $( this );
        var $hidden = $( '#' + $input.attr('id').replace('autocomplete_product_name', 'product_id') );
        $hidden.val(ui.item.id);
      }
    });
  }

  return {
    options: options,
    setupAutocomplete: setupAutocomplete
  }
}()

Comman.factory_making_orders.edit = function() {
  var init = function() {
    $( '.new-fields-container' ).data('afterAppend', Comman.factory_making_orders.setupAutocomplete);
    Comman.factory_making_orders.setupAutocomplete();
  }

  return {
    init: init
  }
}()

Comman.factory_making_orders.create = Comman.factory_making_orders.edit;
Comman.factory_making_orders.update = Comman.factory_making_orders.edit;
Comman.factory_making_orders.new = Comman.factory_making_orders.edit;