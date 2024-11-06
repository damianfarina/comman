import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--removable"
export default class extends Controller {
  static values = {
    showDelay: { type: Number, default: 200 },
    removeDelay: { type: Number, default: 5000 },
    dismissAfter: { type: Boolean, default: true },
  };
  static classes = ["show", "hide"];

  initialize() {
    this.hide();
  }

  connect() {

    // Auto show (default hidden)
    setTimeout(() => {
      this.show();

      // Auto dismiss if defined
      if (this.dismissAfterValue) {
        setTimeout(() => {
          this.close();
        }, this.removeDelayValue);
      }
    }, this.showDelayValue);
  }

  close() {
    this.hide();

    setTimeout(() => {
      this.element.remove();
    }, this.removeDelayValue);
  }

  show() {
    this.element.classList.add(...this.showClasses);
    this.element.classList.remove(...this.hideClasses);
  }

  hide() {
    this.element.classList.add(...this.hideClasses);
    this.element.classList.remove(...this.showClasses);
  }
}
