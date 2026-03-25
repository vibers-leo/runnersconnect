import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    raceId: String
  }

  updateBibNumber(event) {
    const input = event.target
    const registrationId = input.dataset.registrationId
    const newBibNumber = input.value
    const originalValue = input.dataset.originalValue

    // 값이 변경되지 않았으면 아무것도 하지 않음
    if (newBibNumber === originalValue) {
      return
    }

    fetch(`/organizer/races/${this.raceIdValue}/bib_numbers/${registrationId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ bib_number: newBibNumber })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // 성공 피드백 - 녹색 테두리 깜빡임
        input.classList.add('border-green-500', 'bg-green-50')
        input.dataset.originalValue = newBibNumber // 새 값을 원래 값으로 업데이트

        setTimeout(() => {
          input.classList.remove('border-green-500', 'bg-green-50')
        }, 1000)
      } else {
        // 실패 시 원래 값으로 복구
        alert(data.error || '등번호 변경에 실패했습니다.')
        input.value = originalValue
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('서버 오류가 발생했습니다.')
      input.value = originalValue
    })
  }
}
