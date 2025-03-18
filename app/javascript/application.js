// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import "@rails/request.js"
import "trix"
import "@rails/actiontext"
import "chartkick"
import "Chart.bundle"


Turbo.config.drive.progressBarDelay = 100
