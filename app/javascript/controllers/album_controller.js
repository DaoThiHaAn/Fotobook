import { Controller } from "@hotwired/stimulus"

const maxPhotosValue = 25 // Default to 25 if not set

export default class extends Controller {
  static targets = ["photosWrapper", "addPhotoBtn", "fileField", "previewWrapper"]
  static values = { maxPhotos: Number }

  connect() {
    console.log("album_controller connected")
    this.updateAddButtonVisibility()
  }

  get currentPhotoCount() {
    // For new albums, just count the number of previews
    return this.previewWrapperTarget.querySelectorAll('.img-preview-container').length
  }

  addPhotoField() {
    this.fileFieldTarget.click()
  }

  previewPhotos(event) {
    const files = Array.from(event.target.files)

    const max = 25

    if (files.length > max) {
      alert(`You can upload up to ${max} photos only.`)
      // Optionally clear the input and previews
      this.fileFieldTarget.value = ""
      this.previewWrapperTarget.innerHTML = ""
      return
    }

    this.previewWrapperTarget.innerHTML = "" // Clear previous previews

    files.forEach(file => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const div = document.createElement('div')
        div.className = "img-preview-container"
        div.innerHTML = `
        <i class="fa-solid fa-xmark fa-large"
           title="Delete"
           data-image-upload-target="delIcon"
           data-action="click->image-upload#deleteImg"></i>
        <img src="${e.target.result}" class="img-thumbnail" alt="Preview" />`
        this.previewWrapperTarget.appendChild(div)
      }
      reader.readAsDataURL(file)
    })

    this.updateAddButtonVisibility()
  }

  updateAddButtonVisibility() {
    if (this.currentPhotoCount >= maxPhotosValue) {
      this.addPhotoBtnTarget.classList.replace("d-flex", "d-none")
    } else {
      this.addPhotoBtnTarget.classList.replace("d-none", "d-flex")
    }
  }
}
