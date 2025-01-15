import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="common--print-page"
export default class extends Controller {
  connect() {
    this.element.addEventListener("click", (e) => {
      e.preventDefault();
      window.print();
    }
  )}

  disconnect() {
    this.element.removeEventListener("click");
  }
}
