import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="insert-in-reviews"
export default class extends Controller {
  static targets = ["modal"];

  connect() {
    console.log("Hello from insert-in-reviews.js");
    this.modalElement = new bootstrap.Modal(this.modalTarget);
  }

  openModal() {
    this.modalElement.show();
  }
}
