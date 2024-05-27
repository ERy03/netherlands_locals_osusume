import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="heart-icon"
export default class extends Controller {
  static targets = ["heartIcon"];

  hover() {
    this.heartIconTarget.classList.remove("fa-regular");
    this.heartIconTarget.classList.add("fa-solid");
    this.heartIconTarget.style.color = "rgba(255, 100, 100, 0.869)";
  }

  unhover() {
    this.heartIconTarget.classList.remove("fa-solid");
    this.heartIconTarget.classList.add("fa-regular");
    this.heartIconTarget.style.color = "";
  }

  // TODO
  click() {
    console.log("click")
  }
}
