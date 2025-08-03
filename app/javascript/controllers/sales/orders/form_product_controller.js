import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

// Connects to data-controller="sales--orders--form-product"
export default class extends Controller {
  static values = { productsUrl: String };
  static targets = ["price", "quantity"];

  async itemSelected(event) {
    const itemId = event.detail.itemId;
    const response = await get(`${this.productsUrlValue}/${itemId}`, {
      responseKind: "json",
    });
    const product = await response.json;

    this.priceTarget.value = product.price;
    this.priceTarget.dispatchEvent(new Event("input", { bubbles: true }));
    this.quantityTarget.style.backgroundColor = product.stock_level_color;
    this.quantityTarget.focus();
  }
}
