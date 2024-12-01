import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--switch"
export default class extends Controller {
  static outlets = ["input"];

  connect() {
    this.sync();
  }

  toggle() {
    this.inputOutletElement.checked = !this.inputOutletElement.checked;
    this.sync();
  }

  sync() {
    if (this.inputOutletElement.checked) {
      this.element.dataset.checked = true;
      this.element.ariaChecked = true;
    } else {
      delete this.element.dataset.checked;
      this.element.ariaChecked = false;
    }
  }
}
