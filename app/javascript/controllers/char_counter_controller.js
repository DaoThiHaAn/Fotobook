import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter"]

  connect() {
    console.log("char_counter_controller connected")
    this.update() // Initialize counter on connect
  }
  
  update() {
    const length = this.inputTarget.value.length
    this.counterTarget.textContent = `${length}`
  }
}
