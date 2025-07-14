import { Controller } from "@hotwired/stimulus";
import debounce from "lib/debounce";
import { get } from "@rails/request.js";

// Connects to data-controller="common--dropdown"
export default class extends Controller {
  static targets = [
    "button",
    "item",
    "itemTemplate",
    "menu",
    "searchInput",
    "valueInput",
  ];
  static classes = ["hidden", "selected"];
  static values = {
    fetchUrl: String,
    minKeywordLength: { type: Number, default: 2 },
  };

  connect() {
    this.open = false;
    document.addEventListener("click", this.#handleClickOutside);
  }

  initialize() {
    this.filter = debounce(this.filter.bind(this), 200);
  }

  disconnect() {
    document.removeEventListener("click", this.#handleClickOutside);
    if (this.controller) {
      this.controller.abort();
      this.controller = null;
    }
  }

  focus() {
    this.open = true;
  }

  focusNext(event) {
    event.stopImmediatePropagation();
    const currentIndex = this.itemTargets.indexOf(document.activeElement);
    const nextIndex = (currentIndex + 1) % this.itemTargets.length;
    if (!this.itemTargets[nextIndex]) {
      return;
    }
    requestAnimationFrame(() => this.itemTargets[nextIndex].focus());
  }

  focusPrevious(event) {
    event.stopImmediatePropagation();
    const currentIndex = this.itemTargets.indexOf(document.activeElement);

    if (currentIndex === 0) {
      this.searchInputTarget.focus();
      return;
    }

    requestAnimationFrame(() => this.itemTargets[currentIndex - 1].focus());
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
      this.filter();
    });
  }

  async filter() {
    if (this.controller) {
      this.controller.abort();
    }
    this.controller = new AbortController();
    const signal = this.controller.signal;

    this.itemTargets.forEach((item) => item.remove());
    const keyword = this.searchInputTarget.value.toLowerCase();

    if (keyword.length < this.minKeywordLengthValue) {
      this.open = false;
      this.#updateMenu();
      return;
    }

    const queryParams = { "q[id_or_name_cont]": keyword };
    let response;
    try {
      response = await get(this.fetchUrlValue, {
        signal,
        query: queryParams,
        responseKind: "json",
      });
    } catch (error) {
      if (error.name === "AbortError") {
        return;
      }
      throw error;
    }
    this.controller = null;
    this.itemTargets.forEach((item) => item.remove());
    const items = await response.json;
    items.forEach(this.#addItem);

    this.open = items.length > 0;
    this.#updateMenu();
  }

  select(event) {
    event.stopImmediatePropagation();
    const selectedItem = event.currentTarget;
    this.itemTargets.forEach((item) => {
      item.classList.remove(...this.selectedClasses);
    });
    selectedItem.classList.add(...this.selectedClasses);
    this.searchInputTarget.focus();
    this.close();
    this.#updateInputs(selectedItem);
  }

  close() {
    this.open = false;
    if (this.valueInputTarget.value === "") {
      this.searchInputTarget.value = "";
    } else {
      this.searchInputTarget.value = this.valueInputTarget.dataset.label;
    }
    this.#updateMenu();
  }

  // private

  #addItem = (item) => {
    const content = this.itemTemplateTarget.innerHTML
      .replace(/ITEM_VALUE/g, item.id)
      .replace(/ITEM_LABEL/g, item.name);
    this.menuTarget.insertAdjacentHTML("beforeend", content);
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

  #handleClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  };

  #updateInputs(item) {
    if (item) {
      this.searchInputTarget.value = item.dataset.label;
      this.valueInputTarget.value = item.dataset.value;
      this.valueInputTarget.dataset.label = item.dataset.label;
    }
  }
}
