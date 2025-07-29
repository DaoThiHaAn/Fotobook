import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["previewImage", "previewWrapper", "imgBtn", "fileField", "preview"]

    connect() {
        console.log("image_controller connected")
    }


    preview(event) {
        const input = event.target
        const file = input.files[0]

        if (file && file.type.startsWith("image/")) {
            const reader = new FileReader()

            reader.onload = e => {
            this.previewImageTarget.src = e.target.result
            this.previewWrapperTarget.classList.remove("d-none")
            input.previousElementSibling.style.display = "none" // hide the plus button
            }

            reader.readAsDataURL(file)
        }
    }

    previewImage() {
        const input = this.fileFieldTarget
        const file = input.files[0]

        if (file) {
            const reader = new FileReader()

            reader.onload = (event) => {
                // Set the src of the preview target to the new image data
                this.previewTarget.src = event.target.result
            }

            reader.readAsDataURL(file)
        }
    }

    changeAvatar() {
        this.fileFieldTarget.click()
        this.fileFieldTarget.addEventListener("change", this.preview.bind(this), { once: true })
        // Reset the preview image when changing avatar
        this.previewImageTarget.src = ""
        this.previewWrapperTarget.classList.add("d-none")
        this.fileFieldTarget.previousElementSibling.style.display = "block" // show the plus button again
    }
}
