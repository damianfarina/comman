import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["backdrop", "menu"];
  static classes = [
    "hidden", // applied to the backdrop after animation ends
    "backdropShowing", // applied to the backdrop when the menu is open
    "backdropHiding", // applied to the backdrop when the menu is closed
    "menuShowing", // applied to the menu when the menu is open
    "menuHiding", // applied to the menu when the menu is closed
  ];

  open() {
    this.backdropTarget.classList.remove(...this.hiddenClasses);

    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove(...this.backdropHidingClasses);
      this.menuTarget.classList.add(...this.menuShowingClasses);
      this.menuTarget.classList.remove(
        ...this.hiddenClasses,
        ...this.menuHidingClasses
      );
      this.backdropTarget.classList.add(...this.backdropShowingClasses);
    });
  }

  close() {
    // Start the close animation
    this.backdropTarget.classList.add(...this.backdropHidingClasses);
    this.backdropTarget.classList.remove(...this.backdropShowingClasses);
    this.menuTarget.classList.add(...this.menuHidingClasses);
    this.menuTarget.classList.remove(...this.menuShowingClasses);

    // Wait for transition to end, then hide the backdrop
    this.backdropTarget.addEventListener(
      "transitionend",
      () => {
        this.backdropTarget.classList.add(...this.hiddenClasses);
      },
      { once: true }
    );
  }

  outsideMenuTap(event) {
    // Close the menu if the click is somewhere outside the menu contents
    if (event.target === this.menuTarget) {
      this.close()
    }
  }
}
