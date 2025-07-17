// TODO: Toogle password visibility, dynamic conditions, pw confirmation
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "pwField", "eyeIcon" ]

    connect() {
        console.log("auth_controller.js connected!")
    }

    togglePw() {
        const classes = this.eyeIconTarget.classList
        if (classes.contains("fa-eye")) {
            classes.remove("fa-eye")
            classes.add("fa-eye-slash")
            this.pwFieldTarget.type = "text"
        }
        else {
            classes.remove("fa-eye-slash")
            classes.add("fa-eye")
            this.pwFieldTarget.type = "password"
        }
    }
}