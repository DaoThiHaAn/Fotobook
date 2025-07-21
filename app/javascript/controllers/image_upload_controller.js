import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["previewImage", "previewWrapper"]

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
}
