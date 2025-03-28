import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { French } from "./fr.js"

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      locale: French,
      enableTime: this.hasEnableTimeValue ? this.enableTimeValue : false,
      dateFormat: this.hasEnableTimeValue ? "Y-m-d H:i" : "Y-m-d",
      time_24hr: true,
      disableMobile: true
    })
  }

  static values = {
    enableTime: Boolean
  }
}
