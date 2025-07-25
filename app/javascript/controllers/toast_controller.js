    // app/javascript/controllers/toast_controller.js
    import { Controller } from "@hotwired/stimulus";

    export default class extends Controller {
      connect() {
        console.log("toast_controller connected!")
        this.showToast();
      }

      showToast() {
        const toastEl = this.element;
        const toast = new bootstrap.Toast(toastEl);
        toast.show();
      }
    }