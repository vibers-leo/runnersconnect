import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  decrease() {
    const current = parseInt(this.inputTarget.value) || 1
    if (current > 1) {
      this.inputTarget.value = current - 1
    }
  }

  increase(event) {
    const current = parseInt(this.inputTarget.value) || 1
    const max = parseInt(event.currentTarget.dataset.max) || 99
    if (current < max) {
      this.inputTarget.value = current + 1
    }
  }
}
