import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--combobox-input"
export default class extends Controller {
  static targets = ["button", "menu", "option", "input"];
  static classes = ["highlight", "hidden"];

  connect() {
    this.open = false;
    this.selectedOption = null;
    this.filterOptions();
  }

  toggle() {
    this.open = !this.open;
    this.updateMenu();
  }

  close() {
    this.open = false;
    this.updateMenu();
  }

  select(event) {
    this.selectedOption = event.currentTarget;
    this.close();
    this.updateButton();
  }

  highlight(event) {
    this.optionTargets.forEach((option) =>
      option.classList.remove(...this.highlightClasses)
    );
    event.currentTarget.classList.add(...this.highlightClasses);
  }

  filter(event) {
    const query = event.target.value.toLowerCase();
    this.optionTargets.forEach((option) => {
      const text = option.textContent.toLowerCase();
      option.classList.toggle(...this.hiddenClasses, !text.includes(query));
    });
    this.open = true;
    this.updateMenu();
  }

  filterOptions() {
    const query = this.inputTarget.value.toLowerCase();
    this.optionTargets.forEach((option) => {
      const text = option.textContent.toLowerCase();
      option.classList.toggle(...this.hiddenClasses, !text.includes(query));
    });
  }

  focus() {
    this.open = true;
    this.updateMenu();
  }

  keydown(event) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      this.focusFirstOption();
    }
  }

  focusFirstOption() {
    const firstVisibleOption = this.optionTargets.find(
      (option) => !option.classList.contains(...this.hiddenClasses)
    );
    if (firstVisibleOption) {
      firstVisibleOption.focus();
    }
  }

  updateMenu() {
    if (this.open) {
      this.menuTarget.classList.remove(...this.hiddenClasses);
      this.buttonTarget.setAttribute("aria-expanded", "true");
    } else {
      this.menuTarget.classList.add(...this.hiddenClasses);
      this.buttonTarget.setAttribute("aria-expanded", "false");
    }
  }

  updateButton() {
    if (this.selectedOption) {
      this.buttonTarget.querySelector("span").textContent =
        this.selectedOption.querySelector("span").textContent;
    }
  }
}
