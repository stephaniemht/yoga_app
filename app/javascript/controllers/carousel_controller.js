import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.index = 0
    this.update()
  }

  get slides() {
    return this.trackTarget.children
  }

  next() {
    if (this.slides.length === 0) return
    this.index = (this.index + 1) % this.slides.length
    this.update()
  }

  previous() {
    if (this.slides.length === 0) return
    this.index = (this.index - 1 + this.slides.length) % this.slides.length
    this.update()
  }

  update() {
    const offset = -this.index * 100
    this.trackTarget.style.transform = `translateX(${offset}%)`
  }
}
