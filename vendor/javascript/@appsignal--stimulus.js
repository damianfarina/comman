// @appsignal/stimulus@1.0.19 downloaded from https://ga.jspm.io/npm:@appsignal/stimulus@1.0.19/dist/esm/index.js

function installErrorHandler(r,n){var e=n.handleError;n.handleError=function(n,t,o){var i=r.createSpan((function(r){return r.setAction((o===null||o===void 0?void 0:o.identifier)||"[unknown Stimulus controller]").setTags({framework:"Stimulus",message:t}).setError(n)}));r.send(i);e&&typeof e==="function"&&e.apply(this,arguments)}}export{installErrorHandler};

