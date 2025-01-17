import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--options-dropdown"
export default class extends Controller {
  static targets = ["button", "menu"];
  static classes = [
    "bottomPosition",
    "leftPosition",
    "rightPosition",
    "topPosition",
    "buttonOpen",
    "menuClose",
    "menuOpen",
  ];

  isOpen = false;

  connect() {
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this);
    this.menuTarget.style.display = "none";
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

  open() {
    this.isOpen = true;
    document.addEventListener("click", this.closeOnClickOutside);

    this.menuTarget.style.display = "";
    requestAnimationFrame(() => {
      this.menuTarget.classList.remove(...this.menuCloseClasses);
      this.menuTarget.classList.add(
        ...this.menuOpenClasses,
        ...this._calculatePositionClasses(),
      );
      this.buttonTarget.classList.add(...this.buttonOpenClasses);
    });
  }

  close() {
    this.isOpen = false;

    this.menuTarget.addEventListener(
      "transitionend",
      () => {
        this.menuTarget.style.display = "none";
        this.menuTarget.classList.remove(
          ...this.bottomPositionClasses,
          ...this.leftPositionClasses,
          ...this.rightPositionClasses,
          ...this.topPositionClasses,
        );
      },
      { once: true },
    );

    this.menuTarget.classList.remove(...this.menuOpenClasses);
    this.menuTarget.classList.add(...this.menuCloseClasses);
    this.buttonTarget.classList.remove(...this.buttonOpenClasses);
    document.removeEventListener("click", this.closeOnClickOutside);
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  private;

  _calculatePositionClasses() {
    const { top, right, bottom, left } =
      this.buttonTarget.getBoundingClientRect();
    const horizontalCenter = (left + right) / 2;
    const verticalCenter = (top + bottom) / 2;
    const { innerHeight, innerWidth } = window;
    const classes = [];

    if (verticalCenter < innerHeight / 2) {
      classes.push(...this.bottomPositionClasses);
    } else {
      classes.push(...this.topPositionClasses);
    }

    if (horizontalCenter < innerWidth / 2) {
      classes.push(...this.rightPositionClasses);
    } else {
      classes.push(...this.leftPositionClasses);
    }

    return classes;
  }
}
