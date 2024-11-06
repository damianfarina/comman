import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--options-dropdown"
export default class extends Controller {
  static targets = ["button", "menu"];

  isOpen = false;

  connect() {
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this);
  }

  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside);
  }

  close() {
    this.isOpen = false;

    // FIXME: enabla passing classes as arguments
    this.menuTarget.classList.remove("opacity-100", "scale-100");
    this.menuTarget.classList.add("opacity-0", "scale-95");
    this.buttonTarget.classList.remove("bg-lightGray-100");
    document.removeEventListener("click", this.closeOnClickOutside);
  }

  open() {
    this.isOpen = true;
    this.menuTarget.classList.remove("opacity-0", "scale-95");
    this.menuTarget.classList.add("opacity-100", "scale-100");
    this.buttonTarget.classList.add("bg-lightGray-100");
    document.addEventListener("click", this.closeOnClickOutside);
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }
}
