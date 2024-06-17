import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="icons"
export default class extends Controller {
  static targets = ["heartIcon", "shareIcon"];

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
    console.log("click");
  }

  async share(e) {
    e.preventDefault();

    const url = window.location.href;
    const title = document.title;

    const shareData = {
      title: title,
      text: "I found a new Ossume!",
      url: url,
    };

    if (navigator.canShare) {
      try {
        await navigator.share(shareData);
        console.log("Successfully shared");
      } catch (error) {
        console.error("Error sharing", error);
      }
    } else {
      alert("Your browser doesn't support the Web Share API.");
    }
  }
}
