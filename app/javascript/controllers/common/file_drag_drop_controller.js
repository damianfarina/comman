import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="common--file-drag-drop"
export default class extends Controller {
  static targets = ["fileInput"];
  static classes = ["dragOver"];
  static values = {
    accept: { type: String, default: "image/*" },
    maxSize: { type: Number, default: 10 * 1024 * 1024 }, // 10 MB
  };

  connect() {
    this.handleDragOver = this.handleDragOver.bind(this);
    this.handleDragLeave = this.handleDragLeave.bind(this);
    this.handleDrop = this.handleDrop.bind(this);

    this.element.addEventListener("dragover", this.handleDragOver);
    this.element.addEventListener("dragleave", this.handleDragLeave);
    this.element.addEventListener("drop", this.handleDrop);
  }

  disconnect() {
    this.element.removeEventListener("dragover", this.handleDragOver);
    this.element.removeEventListener("dragleave", this.handleDragLeave);
    this.element.removeEventListener("drop", this.handleDrop);
  }

  handleDrop(event) {
    event.preventDefault();
    event.stopPropagation();

    if (!event.dataTransfer.items) {
      return;
    }

    const files = [];
    [...event.dataTransfer.items].forEach((item) => {
      if (item.kind === "file") {
        const file = item.getAsFile();
        if (file.size > this.maxSizeValue) {
          alert(
            `File size exceeds the maximum limit of ${
              this.maxSizeValue / 1024 / 1024
            } MB`,
          );
          return;
        }

        const accepted = this.acceptValue.split(",");
        const isAccepted = accepted.some((type) => {
          type = type.trim();
          if (type.endsWith("/*")) {
            return file.type.startsWith(type.slice(0, -1));
          }
          return file.type === type;
        });

        if (!isAccepted) {
          alert(
            `File type not accepted. Only ${this.acceptValue} are allowed.`,
          );
          return;
        }

        files.push(file);
      }
    });

    if (files.length === 0) {
      alert("No valid files dropped.");
      return;
    }

    const dataTransfer = new DataTransfer();
    const multiple = this.fileInputTarget.hasAttribute("multiple");

    (multiple ? files : [files[0]]).forEach((file) =>
      dataTransfer.items.add(file),
    );

    this.fileInputTarget.files = dataTransfer.files;

    this.fileInputTarget.dispatchEvent(new Event("input", { bubbles: true }));
    this.element.classList.remove(this.dragOverClass);
  }

  handleDragOver(event) {
    event.preventDefault();
    event.stopPropagation();

    this.element.classList.add(this.dragOverClass);
  }
  handleDragLeave(event) {
    event.preventDefault();
    event.stopPropagation();

    this.element.classList.remove(this.dragOverClass);
  }
}
