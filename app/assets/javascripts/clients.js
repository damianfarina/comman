Comman.namespace("business_clients");
Comman.business_clients.action_new = function() {

  var init = function() {
    prepareForm();
  },

  prepareForm = function() {
    $('#client_admission_date').datepicker({
      dateFormat: "dd/mm/yy"
    });
  };


  return {
    init: init
  }
}();

Comman.business_clients.action_edit = Comman.business_clients.action_new;
Comman.business_clients.action_create = Comman.business_clients.action_new;
