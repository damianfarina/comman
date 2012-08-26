Comman.namespace("factory_formulas");
Comman.factory_formulas = function() {
  var options = {};

  var init = function() {
    $( '.new-fields-container' ).data('afterAppend', setupAutocomplete);
    setupAutocomplete();
  }
  
  var setupAutocomplete = function() {
    $('.autocomplete-formula-element-name').autocomplete({
      source: Comman.factory_formulas.options.source,
      minLength: 2,
      select: function( event, ui ) {
        var $input = $( this );
        var $hidden = $( '#' + $input.attr('id').replace('autocomplete_formula_element_name', 'formula_element_id') );
        $hidden.val(ui.item.id);
      }
    });
  }

  return {
    init: init,
    options: options
  }
}();

Comman.factory_formulas.update = Comman.factory_formulas;
Comman.factory_formulas.create = Comman.factory_formulas;
Comman.factory_formulas.edit = Comman.factory_formulas;
Comman.factory_formulas.new = Comman.factory_formulas;