// app/javascript/controllers/course_recurring_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "block"]

  connect() {
    this.toggle()
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      this.blockTarget.classList.remove("is-hidden")
    } else {
      this.blockTarget.classList.add("is-hidden")
    }
  }
}
