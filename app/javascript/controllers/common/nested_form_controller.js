import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--nested-form"
export default class extends Controller {
  static targets = ["container", "template", "destroyField", "item"];
  static classes = ["deleted"];

  /**
   * Adds a new item by cloning the template and replacing "NEW_RECORD" with a unique timestamp.
   */
  addItem() {
    const uniqueId = Date.now();
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, uniqueId)
    this.containerTarget.insertAdjacentHTML("beforeend", content);
  }

  /**
   * Removes an item. Marks it for deletion if it exists, or removes it from the DOM if it is new.
   * @param {Event} event - The click event triggered by the "Remove" button.
   */
  removeItem(event) {
    const item = event.target.closest("[data-common--nested-form-target='item']");
    const destroyField = item.querySelector("[data-common--nested-form-target='destroyField']");

    if (destroyField) {
      if (item.dataset.itemId) {
        destroyField.value = true;
        item.classList.add(...this.deletedClasses);
        item.querySelectorAll('input.not[type="hidden"], select').forEach(input => (input.disabled = true));
      } else {
        item.remove();
      }
    }
  }
}
