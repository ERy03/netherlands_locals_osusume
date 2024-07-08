import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="insert-in-reviews"
export default class extends Controller {
  static targets = [
    "modal",
    "reviews",
    "form",
    "error",
    "reviewCount",
    "ratingCount",
  ];

  connect() {
    this.modalElement = new bootstrap.Modal(this.modalTarget);
    this.openModal = this.openModal.bind(this);
    this.replaceForm = this.replaceForm.bind(this);
    this.updateReviewCount = this.updateReviewCount.bind(this);
    this.clearForm = this.clearForm.bind(this);
  }

  openModal() {
    this.modalElement.show();
  }

  send(event) {
    event.preventDefault();

    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch(this.formTarget.action, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": token,
      },
      body: new FormData(this.formTarget),
    })
      .then((response) => {
        if (!response.ok) {
          throw response;
        }
        return response.json();
      })
      .then((data) => {
        if (data.inserted_item) {
          this.reviewsTarget.insertAdjacentHTML(
            "beforebegin",
            data.inserted_item
          );
          this.modalElement.hide();
          this.updateReviewCount(data.new_review_count);
          this.updateRatingCount(data.new_rating_count);
          this.clearForm();
        }
      })
      .catch((error) => {
        if (error instanceof Response) {
          error.json().then((errorData) => {
            if (errorData.form) {
              this.replaceForm(errorData.form);
            } else {
              if (errorData.errors) {
                this.displayErrors(errorData.errors);
              } else if (errorData.error.includes("sign in")) {
                // If the error message indicates a sign-in requirement, redirect
                window.location.href = "/users/sign_in";
                this.modalElement.hide();
              } else {
                this.displayErrors(error);
              }
            }
          });
        } else {
          this.displayErrors(error);
        }
      });
  }

  replaceForm(html) {
    this.formTarget.outerHTML = html;
  }

  updateReviewCount(newCount) {
    this.reviewCountTarget.innerText = `(${newCount})`;
  }

  updateRatingCount(newRating) {
    if (newRating % 1 === 0) {
      newRating = newRating.toFixed(1);
    }
    const pTag = this.ratingCountTarget.querySelector("p");
    if (pTag) {
      pTag.innerText = `${newRating}`;
    }
  }

  clearForm() {
    this.formTarget.reset();
    this.errorTarget.classList.add("d-none");
    this.errorTarget.innerText = "";
  }

  displayErrors(errors) {
    this.errorTarget.innerText = errors.join(", ");
    this.errorTarget.classList.remove("d-none");
  }
}
