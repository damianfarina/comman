import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--image-preview"
export default class extends Controller {
  static targets = ["canvas", "source"];

  show() {
    const reader = new FileReader();

    reader.onload = () => this.canvasTarget.src = reader.result;

    reader.readAsDataURL(this.sourceTarget.files[0]);
  }
}
