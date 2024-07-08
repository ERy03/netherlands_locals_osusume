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
  static targets = ["form", "list", "searchInput", "sorting", "filter"];

  connect() {
    this.update = debounce(this.update.bind(this), 300);
    this.sort = this.sort.bind(this);
    this.filter = this.filter.bind(this);
    this.fetchData();
  }

  fetchData() {
    const sortValue = this.sortingTarget.value;
    const filterValue = this.filterTarget.value;
    const searchValue = this.searchInputTarget.value
    const url = `${this.formTarget.action}?query=${searchValue}&sort=${sortValue}&filter=${filterValue}`;

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

  update(event) {
    event.preventDefault();
    this.fetchData();
  }

  sort(event) {
    event.preventDefault();
    this.fetchData();
  }

  filter(event) {
    event.preventDefault();
    this.fetchData();
  }
}
