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

  async share() {
    const url = window.location.href;
    console.log(document.title);
    if (navigator.share) {
      try {
        await navigator
          .share({
            title: "Check this out!",
            text: "I found a new Ossume we could try out!",
            url: url,
          });
          console.log("Successfully shared");
      } catch (error) {
        console.error("Error sharing", error);
      }
    } else {
      alert("Your browser doesn't support the Web Share API.");
    }
  }
}
