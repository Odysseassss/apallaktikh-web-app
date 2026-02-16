import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Προσθέτουμε το "clearButton" στα targets
  static targets = ["input", "clearButton"]

  connect() {
    this.clickOutsideHandler = this.closeSearch.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
    // Εκτέλεση κατά τη σύνδεση για να κρυφτεί το X αν το input είναι άδειο
    this.toggleClearButton()
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  // app/javascript/controllers/search_controller.js

submit() {
  this.toggleClearButton()

  clearTimeout(this.timeout)
  this.timeout = setTimeout(() => {
    // ΑΥΤΗ ΕΙΝΑΙ Η ΚΡΙΣΙΜΗ ΑΛΛΑΓΗ:
    // Επειδή το data-controller είναι στο <li>, το this.element είναι το <li>.
    // Πρέπει να βρούμε τη φόρμα μέσα σε αυτό.
    const form = this.element.querySelector("form")
    if (form) {
      form.requestSubmit()
    }
  }, 300) 
}

  toggleClearButton() {
    if (this.hasClearButtonTarget) {
      // Αν το input έχει κείμενο, δείξε το X, αλλιώς κρύψτο
      const isVisible = this.inputTarget.value.length > 0
      this.clearButtonTarget.style.display = isVisible ? "block" : "none"
    }
  }

  closeSearch(event) {
    if (!this.element.contains(event.target)) {
      const frame = document.getElementById("search_results")
      if (frame) {
        frame.innerHTML = ""
      }
    }
  }

  clear() {
    this.inputTarget.value = ""
    this.toggleClearButton() // Κρύβει το X αμέσως
    
    const frame = document.getElementById("search_results")
    if (frame) {
      frame.innerHTML = ""
      frame.removeAttribute("src")
    }
    
    this.inputTarget.focus()
  }
}