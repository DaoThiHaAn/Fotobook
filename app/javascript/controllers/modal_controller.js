// app/javascript/controllers/bootstrap_modal_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bootstrap-modal"
export default class extends Controller {
  connect() {
    console.log("modal_controller connected.");
    // Initialize the Bootstrap modal
    this.modal = new bootstrap.Modal(this.element, {
      backdrop: true, // Allow clicking outside to close
      keyboard: true  // Allow ESC key to close
    });
    this.modal.show(); // Show the modal immediately after connection

    // When the modal is hidden by Bootstrap (e.g., via close button, backdrop click, ESC)
    // we want to remove its content from the Turbo Frame.
    this.element.addEventListener('hidden.bs.modal', this.handleHidden.bind(this));
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
    console.log("Bootstrap modal was hidden. Clearing Turbo Frame content.");
    // When Bootstrap hides the modal, we tell the Turbo Frame to navigate to an empty state.
    // This clears the content from the modal Turbo Frame.
    // Targeting _top means a full page reload or navigate, which is not what we want.
    // Instead, we want to clear the 'modal' turbo frame itself.
    // The most reliable way to clear a turbo-frame is to navigate it to a path
    // that renders an empty turbo-frame, or manually clear its innerHTML.
    // For a modal, navigating back to the original page makes sense.
    // Example: redirecting the turbo frame back to root_path or photos_path.
    this.element.closest('turbo-frame').innerHTML = ''; // Clear the content of the parent turbo-frame
    // Also, remove any body classes that show the overlay
    document.body.classList.remove("modal-open");
  }

  // Optional: For handling forms inside the modal
  hideModal(event) {
    if (event.detail.success) {
      this.modal.hide();
    }
  }
}