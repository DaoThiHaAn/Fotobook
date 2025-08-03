import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("push_url_controller connected")
  }

  update(event) {
    let url = null

    // 2. Try the frame's src attribute (if present)
    if (this.element && this.element.src) {
      url = this.element.src
        console.log("Using frame src URL:", url)
    }

    history.replaceState({}, '', url)
    console.log("URL updated successfully to:", url)
  }
}