import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "total", "tab", "content", "editionInput"]
  static values = {
    selectedPrice: Number
  }

  connect() {
    this.selectedPriceValue = 0
  }

  selectEdition(event) {
    // Visual selection
    this.editionInputTargets.forEach(el => {
      el.closest('.edition-card').classList.remove('ring-2', 'ring-blue-600', 'bg-blue-50')
      el.closest('.edition-card').classList.add('bg-white')
    })
    
    const card = event.currentTarget.closest('.edition-card')
    card.classList.remove('bg-white')
    card.classList.add('ring-2', 'ring-blue-600', 'bg-blue-50')
    
    // Update price
    const price = parseInt(event.currentTarget.dataset.price)
    this.selectedPriceValue = price
    
    // Update total display
    this.totalTarget.textContent = new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(price)
    
    // Set hidden input value if needed (for form submission)
    // this.element.querySelector('input[name="race_edition_id"]').value = event.currentTarget.value
  }

  submitForm() {
    const form = this.element.querySelector('form')
    if (form) form.submit()
  }

  switchTab(event) {
    event.preventDefault()
    const tabName = event.currentTarget.dataset.tab
    
    // Reset tabs
    this.tabTargets.forEach(tab => {
      tab.classList.remove('text-blue-600', 'border-blue-600')
      tab.classList.add('text-gray-500', 'border-transparent')
    })
    
    // Activate clicked tab
    event.currentTarget.classList.remove('text-gray-500', 'border-transparent')
    event.currentTarget.classList.add('text-blue-600', 'border-blue-600')
    
    // Show content
    this.contentTargets.forEach(content => {
      if (content.dataset.content === tabName) {
        content.classList.remove('hidden')
      } else {
        content.classList.add('hidden')
      }
    })
  }
}
