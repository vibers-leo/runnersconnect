import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "dropzone",
    "fileInput",
    "preview",
    "previewImage",
    "analyzeButton",
    "loadingState",
    "successState",
    "errorMessage",
    "rawText",
    // Race form fields
    "titleField",
    "descriptionField",
    "locationField",
    "startAtField",
    "registrationStartAtField",
    "registrationEndAtField",
    "refundDeadlineField",
    "organizerField",
    "officialSiteField",
    "isOfficialRecordField",
    // Race editions
    "editionsContainer"
  ]

  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    const dropzone = this.dropzoneTarget

    dropzone.addEventListener('dragover', (e) => {
      e.preventDefault()
      dropzone.classList.add('border-blue-500', 'bg-blue-50')
    })

    dropzone.addEventListener('dragleave', () => {
      dropzone.classList.remove('border-blue-500', 'bg-blue-50')
    })

    dropzone.addEventListener('drop', (e) => {
      e.preventDefault()
      dropzone.classList.remove('border-blue-500', 'bg-blue-50')

      const file = e.dataTransfer.files[0]
      if (file && file.type.startsWith('image/')) {
        this.handleFile(file)
      }
    })
  }

  selectFile(event) {
    const file = event.target.files[0]
    if (file) {
      this.handleFile(file)
    }
  }

  handleFile(file) {
    // 파일 크기 검증
    if (file.size > 5 * 1024 * 1024) {
      this.showError('파일 크기는 5MB 이하여야 합니다')
      return
    }

    // 미리보기 표시
    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewImageTarget.src = e.target.result
      this.previewTarget.classList.remove('hidden')
      this.analyzeButtonTarget.disabled = false
    }
    reader.readAsDataURL(file)

    // File 객체 저장
    this.currentFile = file
  }

  async analyze(event) {
    event.preventDefault()

    if (!this.currentFile) {
      this.showError('이미지를 먼저 선택해주세요')
      return
    }

    try {
      this.showLoading()

      const formData = new FormData()
      formData.append('poster_image', this.currentFile)

      const response = await fetch('/admin/poster_analyses', {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      const result = await response.json()

      if (result.success) {
        this.fillForm(result.data)
        this.showSuccess(result)
      } else {
        this.showError(result.error || '분석에 실패했습니다')
      }
    } catch (error) {
      console.error('Analysis error:', error)
      this.showError('서버에 연결할 수 없습니다. 다시 시도해주세요.')
    } finally {
      this.hideLoading()
    }
  }

  fillForm(data) {
    const { race, race_editions } = data

    // Race 필드 채우기
    if (race.title) this.titleFieldTarget.value = race.title
    if (race.description) this.descriptionFieldTarget.value = race.description
    if (race.location) this.locationFieldTarget.value = race.location
    if (race.start_at) this.startAtFieldTarget.value = this.formatDateForInput(race.start_at)
    if (race.registration_start_at) {
      this.registrationStartAtFieldTarget.value = this.formatDateForInput(race.registration_start_at)
    }
    if (race.registration_end_at) {
      this.registrationEndAtFieldTarget.value = this.formatDateForInput(race.registration_end_at)
    }
    if (race.refund_deadline) {
      this.refundDeadlineFieldTarget.value = this.formatDateForInput(race.refund_deadline)
    }
    if (race.organizer_name) this.organizerFieldTarget.value = race.organizer_name
    if (race.official_site_url) this.officialSiteFieldTarget.value = race.official_site_url
    if (race.is_official_record) this.isOfficialRecordFieldTarget.checked = true

    // Race Editions 채우기 - 기존 필드 찾기 또는 새로 추가
    if (race_editions && race_editions.length > 0) {
      race_editions.forEach((edition, index) => {
        const editionFields = this.editionsContainerTarget.querySelectorAll('.nested-fields')[index]

        if (editionFields) {
          this.fillEditionFields(editionFields, edition)
        }
      })
    }

    // 성공 애니메이션
    this.highlightFilledFields()
  }

  fillEditionFields(container, edition) {
    if (edition.name) {
      const nameField = container.querySelector('[name*="[name]"]')
      if (nameField) nameField.value = edition.name
    }
    if (edition.distance) {
      const distanceField = container.querySelector('[name*="[distance]"]')
      if (distanceField) distanceField.value = edition.distance
    }
    if (edition.price) {
      const priceField = container.querySelector('[name*="[price]"]')
      if (priceField) priceField.value = edition.price
    }
    if (edition.capacity) {
      const capacityField = container.querySelector('[name*="[capacity]"]')
      if (capacityField) capacityField.value = edition.capacity
    }
    if (edition.age_limit_min) {
      const ageField = container.querySelector('[name*="[age_limit_min]"]')
      if (ageField) ageField.value = edition.age_limit_min
    }
  }

  formatDateForInput(dateString) {
    // ISO 8601 → datetime-local input format
    // "2026-03-15T09:00:00+09:00" → "2026-03-15T09:00"
    const date = new Date(dateString)
    return date.toISOString().slice(0, 16)
  }

  highlightFilledFields() {
    // 채워진 필드를 녹색으로 하이라이트 (2초간)
    const fields = [
      this.titleFieldTarget,
      this.locationFieldTarget,
      this.startAtFieldTarget
    ]

    fields.forEach(field => {
      if (field.value) {
        field.classList.add('border-green-500', 'bg-green-50')
        setTimeout(() => {
          field.classList.remove('border-green-500', 'bg-green-50')
        }, 2000)
      }
    })
  }

  showLoading() {
    this.loadingStateTarget.classList.remove('hidden')
    this.analyzeButtonTarget.disabled = true
  }

  hideLoading() {
    this.loadingStateTarget.classList.add('hidden')
    this.analyzeButtonTarget.disabled = false
  }

  showSuccess(result) {
    this.successStateTarget.classList.remove('hidden')

    // 추출된 원본 텍스트 표시 (디버깅용)
    if (result.raw_text && this.hasRawTextTarget) {
      this.rawTextTarget.textContent = result.raw_text
    }

    // 3초 후 성공 메시지 숨김
    setTimeout(() => {
      this.successStateTarget.classList.add('hidden')
    }, 3000)
  }

  showError(message) {
    this.errorMessageTarget.textContent = message
    this.errorMessageTarget.classList.remove('hidden')

    setTimeout(() => {
      this.errorMessageTarget.classList.add('hidden')
    }, 5000)
  }
}
