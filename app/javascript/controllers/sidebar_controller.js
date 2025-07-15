import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "sidebar" ]

    // The 'connect' method is called when this controller is attached to an HTML element
    connect() {
        console.log("sidebar_controller.js connected!")
        this.adjustSidebarPosition()
        
        // Listen for navbar toggle events
        this.setupEventListeners()
        
        // Listen for window resize to recalculate
        window.addEventListener('resize', this.adjustSidebarPosition.bind(this))
    }

    disconnect() {
        window.removeEventListener('resize', this.adjustSidebarPosition.bind(this))
    }

    setupEventListeners() {
        // Listen for Bootstrap navbar collapse events
        const navbarCollapse = document.getElementById('navbar')
        if (navbarCollapse) {
            navbarCollapse.addEventListener('shown.bs.collapse', () => {
                console.log('Navbar expanded')
                this.adjustSidebarPosition()
            })
            
            navbarCollapse.addEventListener('hidden.bs.collapse', () => {
                console.log('Navbar collapsed')
                this.adjustSidebarPosition()
            })
        }
    }

    adjustSidebarPosition() {
        const navbar = document.querySelector('.navbar')
        const sidebar = this.sidebarTarget
        
        if (navbar && sidebar) {
            // Get the actual height of the navbar
            const navbarHeight = navbar.offsetHeight
            console.log('Navbar height:', navbarHeight)
            
            // Update sidebar position
            sidebar.style.top = `${navbarHeight}px`
            sidebar.style.height = `calc(100vh - ${navbarHeight}px)`
            
            // Update content area margin for desktop
            const contentArea = document.querySelector('.content-area')
            if (contentArea && window.innerWidth >= 992) {
                contentArea.style.paddingTop = '0'
            }
        }
    }

    // Method to manually trigger adjustment (can be called from other controllers)
    adjustHeight() {
        this.adjustSidebarPosition()
    }
}