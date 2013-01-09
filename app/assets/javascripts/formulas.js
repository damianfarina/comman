Comman.namespace("factory_formulas");
Comman.factory_formulas = function() {
  var options = {};

  var init = function() {
    prepareAutocomplete();
    prepareClose();
  }

  var prepareClose = function() {
    $('.close.destroy').click(function(){
      var $tr = $(this).closest('tr');
      $tr.find('input[type=hidden].destroy').val('1');
      $tr.hide();
      return false;
    });
  }

  var prepareAutocomplete = function() {
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
        add_formula_item(ui.item.id);
      }
    });
  }

  var add_formula_item = function(formula_element_id) {
    $.ajax({
      url: "/factory/formulas/formula_item",
      data: { formula_element_id: formula_element_id },
      dataType: "html"
    }).done(function(msg){
      var $list = $('#formula_items_list');
      $list.find('tbody').append(msg);
      $('#search_formula_elements').val("");
      $list.find('input[type=text]').last().focus();
    });
  }
  
  return {
    init: init,
    options: options
  }
}();

Comman.factory_formulas.action_update = Comman.factory_formulas;
Comman.factory_formulas.action_create = Comman.factory_formulas;
Comman.factory_formulas.action_edit = Comman.factory_formulas;
Comman.factory_formulas.action_new = Comman.factory_formulas;