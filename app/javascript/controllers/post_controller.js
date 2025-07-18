import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        console.log("post_controller connected")
    }

    toggleFollow(event) {
        const followButton = event.currentTarget;
        if (followButton.classList.contains("active")) { // Folowing
            followButton.classList.replace("active", "gradient-text");
            followButton.title = followButton.dataset.followTitle;
            followButton.textContent = followButton.dataset.followTitle;
        }
        else {
            followButton.classList.replace("gradient-text", "active");
            followButton.title = followButton.dataset.unfollowTitle;
            followButton.textContent = followButton.dataset.followingText;
        }
    }

    toggleHeart(event) {
        const heartIcon = event.currentTarget;
        if (heartIcon.classList.contains("fa-regular")) { //unliked
            heartIcon.classList.replace("fa-regular", "fa-solid")
            heartIcon.title = heartIcon.dataset.unlikeTitle;
        }
        else { 
            heartIcon.classList.replace("fa-solid", "fa-regular")
            heartIcon.title = heartIcon.dataset.likeTitle;
        }
    }
}