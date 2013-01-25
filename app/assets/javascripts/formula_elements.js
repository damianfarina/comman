Comman.namespace("factory_formula_elements");
Comman.factory_formula_elements.action_index = function() {
  var init = function() {
    setupJoinButton();

    var $inputs = $("#formula_elements_list input[type=checkbox]");
    var $join_button = $('#join_formula_elements_button');
    $inputs.change(setupJoinButton);
    $join_button.click(collectElementsToJoin);
  }

  var collectElementsToJoin = function() {
    var formula_element_ids = [];
    $("#formula_elements_list input:checked").each(function(index, element){
      formula_element_ids.push($(element).data().elementId);
    });
    $(this).attr('href', $(this).attr('href') + "?formula_element_ids=" + formula_element_ids.join(','));
    return true;
  }

  var setupJoinButton = function() {
    var $join_button = $('#join_formula_elements_button');
    var $checkboxes = $("#formula_elements_list input:checked");
    if($checkboxes.size() >= 2) {
      $join_button.closest('li').fadeIn('fast');
    } else {
      $join_button.closest('li').fadeOut('fast');
    }
  }

  return {
    init: init
  }
}();