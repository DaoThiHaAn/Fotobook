import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "collapse", "lang" ]

    connect() {
        console.log("navbar_controller.js connected!")
        
        // Initial adjustment
        this.adjustLayout()
        
        // Listen for window resize
        window.addEventListener('resize', this.adjustLayout.bind(this))
    }

    disconnect() {
        window.removeEventListener('resize', this.adjustLayout.bind(this))
    }

    // Called when navbar collapse is toggled
    toggle() {
        console.log("Navbar toggled")
        // Small delay to allow Bootstrap animation to complete
        setTimeout(() => {
            this.adjustLayout()
        }, 150) // Bootstrap collapse animation duration
    }

    adjustLayout() {
        // Find the sidebar controller and trigger adjustment
        const sidebarElement = document.querySelector('[data-controller*="sidebar"]')
        if (sidebarElement) {
            const sidebarController = this.application.getControllerForElementAndIdentifier(sidebarElement, 'sidebar')
            if (sidebarController) {
                sidebarController.adjustSidebarPosition()
            }
        }
    }
}
