// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.index = 0
    this.slides = this.trackTarget.querySelectorAll(".carousel-image")
  }

  previous() {
    if (this.slides.length === 0) return
    this.index = (this.index - 1 + this.slides.length) % this.slides.length
    this.updatePosition()
  }

  next() {
    if (this.slides.length === 0) return
    this.index = (this.index + 1) % this.slides.length
    this.updatePosition()
  }

  updatePosition() {
    const offset = -this.index * 100
    this.trackTarget.style.transform = `translateX(${offset}%)`
  }
}
