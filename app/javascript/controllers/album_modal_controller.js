import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["photo", "currentIndex"]
  static values = { currentIndex: Number }

  connect() {
    console.log("modal_controller connected.");
    // Initialize the Bootstrap modal
    this.modal = new bootstrap.Modal(this.element, {
      backdrop: true, // Allow clicking outside to close
      keyboard: true  // Allow ESC key to close
    });

    // When the modal is hidden by Bootstrap (e.g., via close button, backdrop click, ESC)
    // we want to remove its content from the Turbo Frame.
    this.element.addEventListener('hidden.bs.modal', this.handleHidden.bind(this));
    this.currentIndexTarget.innerHTML = (this.currentIndexValue+1).toString() // Display the current index (1-based)
    this.showPhoto(this.currentIndexValue)

    this.modal.show();
  }

  prevPhoto() {
    if (this.currentIndexValue > 0)
      this.currentIndexValue--
    else
      this.currentIndexValue = this.photoTargets.length - 1 // Loop back to the last photo
    this.showPhoto(this.currentIndexValue)
  }

  nextPhoto() {
    if (this.currentIndexValue < this.photoTargets.length - 1)
      this.currentIndexValue++
    else
        this.currentIndexValue = 0 // Loop back to the first photo  
    this.showPhoto(this.currentIndexValue)

  }

  showPhoto(index) {
  // Find all photo wrapper divs (each has a photo and the index display)
  const wrappers = this.photoTargets.map(img => img.closest('div'));
  wrappers.forEach((wrapper, i) => {
    if (wrapper) {
      wrapper.classList.toggle('d-none', i !== index);
    }
  });
  // Update the current index display (1-based)
  this.currentIndexTargets.forEach(el => {
    el.textContent = (index + 1).toString();
  });
}

disconnect() {
    console.log("Bootstrap modal controller disconnected.");
    // Clean up when the Stimulus controller disconnects (e.g., when Turbo navigates away from the frame)
    if (this.modal) {
      this.modal.hide(); // Ensure the modal is hidden
      this.modal.dispose(); // Clean up Bootstrap's internal state
    }
    this.element.removeEventListener('hidden.bs.modal', this.handleHidden.bind(this));
  }

  handleHidden() {
    this.element.closest('turbo-frame').innerHTML = ''; // Clear the content of the parent turbo-frame
    // Also, remove any body classes that show the overlay
    document.body.classList.remove("modal-open");
  }

  // Optional: For handling forms inside the modal
  hideModal(event) {
    if (event.detail.success) {
      this.modal.hide();
    }
  }}