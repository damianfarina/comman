import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="common--print-page"
export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.handleClick);
  }

  disconnect() {
    this.element.removeEventListener("click", this.handleClick);
  }

  handleClick = (event) => {
    event.preventDefault();
    window.print();
  }
}
