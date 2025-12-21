import { Application } from "@hotwired/stimulus";
import { installErrorHandler } from "@appsignal/stimulus";
import { appsignal } from "lib/appsignal";
import { plugin } from "@appsignal/plugin-window-events";

const application = Application.start();

if (appsignal) {
  appsignal.use(plugin());
  installErrorHandler(appsignal, application);
}

// Configure Stimulus development experience
application.debug = true;
window.Stimulus = application;

export { application };
