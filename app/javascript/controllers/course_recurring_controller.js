import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "block", "countBlock", "count", "slot"]

  connect() {
    this.toggle()       // afficher/masquer le bloc récurrence
    this.updateSlots()  // afficher le bon nombre de créneaux
  }

  toggle() {
    const isRecurring = this.checkboxTarget.checked

    if (isRecurring) {
      this.blockTarget.classList.remove("is-hidden")
      this.countBlockTarget.classList.remove("is-hidden")
      this.updateSlots()
    } else {
      this.blockTarget.classList.add("is-hidden")
      this.countBlockTarget.classList.add("is-hidden")

      // on masque tous les créneaux
      this.slotTargets.forEach((slot) => {
        slot.classList.add("is-hidden")
      })
    }
  }

  updateSlots() {
    // si le bloc récurrence est caché, on ne fait rien
    if (this.blockTarget.classList.contains("is-hidden")) return

    let n = 1
    if (this.hasCountTarget) {
      const value = parseInt(this.countTarget.value, 10)
      if (!isNaN(value) && value >= 1 && value <= 7) {
        n = value
      }
    }

    this.slotTargets.forEach((slot) => {
      const index = parseInt(slot.dataset.index, 10)

      if (index <= n) {
        slot.classList.remove("is-hidden")
      } else {
        slot.classList.add("is-hidden")
      }
    })
  }
}
