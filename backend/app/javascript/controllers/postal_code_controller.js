import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zipcode", "address"]

  connect() {
    this.loaded = false
  }

  search() {
    if (this.loaded) {
      this.openPostcode()
    } else {
      this.loadScript().then(() => {
        this.loaded = true
        this.openPostcode()
      })
    }
  }

  openPostcode() {
    new daum.Postcode({
      oncomplete: (data) => {
        this.zipcodeTarget.value = data.zonecode
        this.addressTarget.value = data.roadAddress || data.jibunAddress
        this.addressTarget.focus()
      }
    }).open()
  }

  loadScript() {
    return new Promise((resolve) => {
      if (window.daum && window.daum.Postcode) {
        resolve()
        return
      }
      const script = document.createElement("script")
      script.src = "https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"
      script.onload = resolve
      document.head.appendChild(script)
    })
  }
}
