import { Controller } from "@hotwired/stimulus"
import debounce from "lib/debounce"

// Connects to data-controller="common--form"
export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 500);
  }

  submit() {
    this.element.requestSubmit();
  }
}
