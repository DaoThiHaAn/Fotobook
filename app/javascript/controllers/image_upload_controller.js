import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["previewWrapper", "imgBtn", "fileField", "preview"]

    connect() {
        console.log("image_controller connected")
    }

    showAddBtn() {
        this.imgBtnTarget.classList.replace("d-none", "d-flex") ;
    }

    hideAddBtn() {
        this.imgBtnTarget.classList.replace("d-flex", "d-none")
    }

    showWrapper() {
        this.previewWrapperTarget.classList.replace("d-none", "d-flex")
    }

    hideWrapper() {
        this.previewWrapperTarget.classList.replace("d-flex", "d-none")
    }

    changeAvatar() {
        this.fileFieldTarget.click()
    }

    // Main functions
    previewAvatar() {
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

    previewPhoto() {
        this.previewAvatar();
        this.showWrapper()
        this.hideAddBtn();
    }

    // remove temporary img from file uploaded input
    deleteImg() {
        this.fileFieldTarget.value = "";
        this.hideWrapper();
        this.showAddBtn();
    }
}
