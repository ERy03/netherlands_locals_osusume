import { Controller } from "@hotwired/stimulus";

// debouncing
function debounce(func, wait) {
  let timeout;
  return function (...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Connects to data-controller="refresh-list"
export default class extends Controller {
  static targets = ["form", "list", "searchInput"];

  connect() {
    this.update = debounce(this.update.bind(this), 300);
  }

  update(event) {
    event.preventDefault();

    const url = `${this.formTarget.action}?query=${this.searchInputTarget.value}`;

    fetch(url, { headers: { Accept: "application/json" } })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        if (data.inserted_item) {
          this.listTarget.innerHTML = data.inserted_item;
        }
      })
      .catch((error) => {
        console.error("There was a problem with the fetch operation:", error);
      });
  }
}
