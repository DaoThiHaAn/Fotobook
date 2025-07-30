import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photosWrapper", "template", "addPhotoBtn", "photoItem", "fileField", "preview"]
  static values = { maxPhotos: Number }

  connect() {
    console.log("album_controller connected")
    this.updateAddButtonVisibility()
  }

  get currentPhotoCount() {
    return this.photoItemTargets.filter(item => {
      const destroyField = item.querySelector('.destroy-field')
      return !destroyField || destroyField.value !== "1"
    }).length
  }

  addPhotoField(event) {
    event.preventDefault()
    if (this.currentPhotoCount >= this.maxPhotosValue) return

    const timestamp = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
    this.photosWrapperTarget.insertAdjacentHTML("beforeend", content)
    this.updateAddButtonVisibility()
  }

  triggerFileUpload(event) {
    const wrapper = event.target.closest('[data-album-target="photoItem"]')
    const fileField = wrapper.querySelector('[data-album-target="fileField"]')
    if (fileField) fileField.click()
  }

  previewPhoto(event) {
    const input = event.target
    const file = input.files[0]
    const wrapper = input.closest('[data-album-target="photoItem"]')
    const preview = wrapper.querySelector('[data-album-target="preview"]')

    if (file && preview) {
      const reader = new FileReader()
      reader.onload = (e) => {
        preview.src = e.target.result
        preview.classList.remove("d-none")

        const uploadBtn = wrapper.querySelector('.upload-btn')
        if (uploadBtn) uploadBtn.classList.add("d-none")
      }
      reader.readAsDataURL(file)
    }
  }

  removePhoto(event) {
    const item = event.target.closest('[data-album-target="photoItem"]')
    const destroyField = item.querySelector('.destroy-field')
    if (destroyField) {
      destroyField.value = "1"
      item.style.display = 'none'
    } else {
      item.remove()
    }
    this.updateAddButtonVisibility()
  }

  removeNewPhoto(event) {
    const item = event.target.closest('[data-album-target="photoItem"]')
    if (item) {
      item.remove()
      this.updateAddButtonVisibility()
    }
  }

  updateAddButtonVisibility() {
    if (this.currentPhotoCount >= this.maxPhotosValue) {
      this.addPhotoBtnTarget.classList.add("d-none")
    } else {
      this.addPhotoBtnTarget.classList.remove("d-none")
    }
  }
}
