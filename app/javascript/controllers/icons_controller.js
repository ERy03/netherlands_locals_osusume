import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="icons"
export default class extends Controller {
  static targets = ["heartIcon", "shareIcon"];
  static values = { liked: Boolean, recommendationId: Number };

  connect() {
    this.updateHeartIcon();
  }

  async click() {
    if (this.likedValue) {
      await this.unlikeRecommendation();
    } else {
      await this.likeRecommendation();
    }
  }

  async likeRecommendation() {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    try {
      const response = await fetch(
        `/recommendations/${this.recommendationIdValue}/like`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": token,
          },
        }
      );
      if (response.redirected) {
        window.location.href = response.url;
      } else {
        const data = await response.json();
        if (response.ok) {
          this.likedValue = data.liked;
          this.updateHeartIcon();
        } else {
          this.showError(data.errors);
        }
      }
    } catch (error) {
      this.showError(["An unexpected error occurred. Please try again later."]);
    }
  }

  async unlikeRecommendation() {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    try {
      const response = await fetch(
        `/recommendations/${this.recommendationIdValue}/like`,
        {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": token,
          },
        }
      );

      if (response.redirected) {
        window.location.href = response.url;
      } else {
        const data = await response.json();
        if (response.ok) {
          this.likedValue = data.liked;
          this.updateHeartIcon();
        } else {
          this.showError(data.errors);
        }
      }
    } catch (error) {
      this.showError(["An unexpected error occurred. Please try again later."]);
    }
  }

  updateHeartIcon() {
    if (this.likedValue) {
      this.heartIconTarget.classList.remove("fa-regular");
      this.heartIconTarget.classList.add("fa-solid");
      this.heartIconTarget.style.color = "rgba(255, 100, 100, 0.869)";
    } else {
      this.heartIconTarget.classList.remove("fa-solid");
      this.heartIconTarget.classList.add("fa-regular");
      this.heartIconTarget.style.color = "";
    }
  }

  showError(errors) {
    alert(errors.join("\n"));
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
