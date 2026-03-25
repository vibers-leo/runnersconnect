import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    raceId: String,
    currentUserName: String
  }

  markReceived(event) {
    const button = event.currentTarget
    const registrationId = button.dataset.registrationId
    const type = button.dataset.type

    const staffName = prompt('수령 확인자 이름을 입력하세요:', this.currentUserNameValue)
    if (!staffName) return

    // 버튼 비활성화
    button.disabled = true
    button.textContent = '처리 중...'

    fetch(`/organizer/races/${this.raceIdValue}/souvenirs/${registrationId}/mark_received`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ type: type, staff_name: staffName })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // 페이지 새로고침으로 업데이트된 상태 표시
        location.reload()
      } else {
        alert(data.error || '수령 체크에 실패했습니다.')
        button.disabled = false
        button.textContent = '수령 체크'
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('서버 오류가 발생했습니다.')
      button.disabled = false
      button.textContent = '수령 체크'
    })
  }
}
