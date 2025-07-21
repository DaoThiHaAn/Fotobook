import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter"]

  connect() {
    console.log("char_counter_controller connected")
  }
  
  update() {
    const length = this.inputTarget.value.length
    this.counterTarget.textContent = `${length}`
  }
}
