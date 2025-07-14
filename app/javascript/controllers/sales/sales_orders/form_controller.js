import { Controller } from "@hotwired/stimulus";
import debounce from "lib/debounce";

// Connects to data-controller="sales--sales-orders--form"
export default class extends Controller {
  static classes = ["animation"];
  static values = {
    productsUrl: String,
  };
  static targets = ["previewButton", "totals", "input"];

  connect() {
    this.updateTotals = debounce(this.updateTotals.bind(this), 500);
  }

  updateTotals() {
    this.previewButtonTarget.click();
    this.totalsTarget.classList.add(...this.animationClasses);
    this.totalsTarget.addEventListener("animationend", () => {
      this.totalsTarget.classList.remove(...this.animationClasses);
    }, { once: true });
  }
}
