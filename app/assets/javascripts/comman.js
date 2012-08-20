/**
 * Comman Javascript library
 */

var Comman = Comman || {};
Comman.namespace = function (ns_string) {
  var parts = ns_string.split('.'),
  parent = Comman,
  i;
  // strip redundant leading global
  if (parts[0] === "Comman") {
    parts = parts.slice(1);
  }
  for (i = 0; i < parts.length; i += 1) {
    // create a property if it doesn't exist
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }
    parent = parent[parts[i]];
  }
  return parent;
}

Comman.exec = function( controller, action ) {
  if ( controller !== "" && Comman[controller] && action !== "" && typeof Comman[controller][action] == "object" && typeof Comman[controller][action].init == "function" ) {
    Comman[controller][action].init();
  }
}

Comman.init = function() {
  var body = document.body,
  controller = body.getAttribute( "data-controller" ),
  action = body.getAttribute( "data-action" );

  Comman.exec( controller, action );
}

$( document ).ready( Comman.init );