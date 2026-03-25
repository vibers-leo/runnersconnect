import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    animation: { type: String, default: "slide-up" },
    delay: { type: Number, default: 0 },
    threshold: { type: Number, default: 0.1 }
  }

  connect() {
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(20px)"
    this.element.style.transition = "opacity 0.6s ease-out, transform 0.6s ease-out"

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setTimeout(() => {
              entry.target.style.opacity = ""
              entry.target.style.transform = ""
            }, this.delayValue)
            this.observer.unobserve(entry.target)
          }
        })
      },
      { threshold: this.thresholdValue }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}
