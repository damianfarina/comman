# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/lib", under: "lib", to: "lib"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "@appsignal/javascript", to: "@appsignal--javascript.js" # @1.5.0
pin "@appsignal/core", to: "@appsignal--core.js" # @1.1.24
pin "https" # @2.1.0
pin "tslib" # @2.8.1
pin "@appsignal/stimulus", to: "@appsignal--stimulus.js" # @1.0.19
pin "@appsignal/plugin-window-events", to: "@appsignal--plugin-window-events.js" # @1.0.24
