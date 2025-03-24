import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--switch"
export default class extends Controller {
  static targets = ["input", "button"];

  connect() {
    this.sync();
  }

  toggle() {
    this.inputTarget.checked = !this.inputTarget.checked;
    this.sync();
    this.inputTarget.dispatchEvent(new Event("input", { 'bubbles': true }));
  }

  sync() {
    if (this.inputTarget.checked) {
      this.buttonTarget.dataset.checked = true;
      this.buttonTarget.ariaChecked = true;
    } else {
      delete this.buttonTarget.dataset.checked;
      this.buttonTarget.ariaChecked = false;
    }
  }
}
