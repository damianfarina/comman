import { Controller } from "@hotwired/stimulus";
import debounce from "lib/debounce";

// Connects to data-controller="common--combobox-input"
export default class extends Controller {
  static targets = ["button", "menu", "option", "searchInput", "valueInput"];
  static classes = ["hidden", "selected"];

  connect() {
    this.open = false;
    document.addEventListener("click", this.#handleClickOutside);
  }

  disconnect() {
    document.removeEventListener("click", this.#handleClickOutside);
  }

  initialize() {
    this.filter = debounce(this.filter.bind(this), 200);
  }

  toggle(event) {
    this.open = !this.open;
    this.#updateMenu();
    this.focusNext(event);
  }

  close() {
    this.open = false;
    this.#updateMenu();
  }

  select(event) {
    event.stopImmediatePropagation();
    const selectedOption = event.currentTarget;
    this.optionTargets.forEach((option) => {
      option.classList.remove(...this.selectedClasses);
    });
    selectedOption.classList.add(...this.selectedClasses);
    this.searchInputTarget.focus();
    this.close();
    this.#updateInputs(selectedOption);
  }

  filter(event) {
    const query = event.target.value.toLowerCase();
    this.optionTargets.forEach((option) => {
      const text = option.textContent.toLowerCase();
      option.classList.toggle(...this.hiddenClasses, !text.includes(query));
    });
    this.open = true;
    this.#updateMenu();
  }

  searchMore(event) {
    const keyValue = event.key;
    const isEscapeKey = event.keyCode === 27;
    const isBackspaceKey = event.keyCode === 8;
    const isNumberKey = event.keyCode >= 48 && event.keyCode <= 57;
    const isUppercaseLetterKey = event.keyCode >= 65 && event.keyCode <= 90;
    const isLowercaseLetterKey = event.keyCode >= 97 && event.keyCode <= 122;

    if (
      !(
        isNumberKey ||
        isUppercaseLetterKey ||
        isLowercaseLetterKey ||
        isBackspaceKey ||
        isEscapeKey
      )
    ) {
      return;
    }

    if (isEscapeKey) {
      this.searchInputTarget.focus();
      this.close();
      return;
    }

    if (isBackspaceKey) {
      this.searchInputTarget.value = this.searchInputTarget.value.slice(0, -1);
    } else {
      this.searchInputTarget.value = this.searchInputTarget.value + keyValue;
    }

    requestAnimationFrame(() => {
      this.searchInputTarget.focus();
      this.filter(event);
    });
  }

  focus() {
    this.open = true;
    this.#updateMenu();
  }

  focusNext(event) {
    event.stopImmediatePropagation();
    const visibleOptions = this.optionTargets.filter(
      (option) => !option.classList.contains(...this.hiddenClasses)
    );
    const currentIndex = visibleOptions.indexOf(document.activeElement);
    const nextIndex = (currentIndex + 1) % visibleOptions.length;
    if (!visibleOptions[nextIndex]) {
      return;
    }
    requestAnimationFrame(() => visibleOptions[nextIndex].focus());
  }

  focusPrevious(event) {
    event.stopImmediatePropagation();
    const visibleOptions = this.optionTargets.filter(
      (option) => !option.classList.contains(...this.hiddenClasses)
    );
    const currentIndex = visibleOptions.indexOf(document.activeElement);

    if (currentIndex === 0) {
      this.searchInputTarget.focus();
      return;
    }

    requestAnimationFrame(() => visibleOptions[currentIndex - 1].focus());
  }

  #updateMenu() {
    if (this.open) {
      this.menuTarget.classList.remove(...this.hiddenClasses);
      this.buttonTarget.setAttribute("aria-expanded", "true");
    } else {
      this.menuTarget.classList.add(...this.hiddenClasses);
      this.buttonTarget.setAttribute("aria-expanded", "false");
    }
  }

  #updateInputs(option) {
    if (option) {
      this.searchInputTarget.value = option.dataset.value;
      this.valueInputTarget.value = option.dataset.id;
    }
  }

  #handleClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  };
}
