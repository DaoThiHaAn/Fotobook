import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        console.log("post_controller connected")
    }

    // Send url to create associaion in db
    toggleFollow(event) {
        const followButton = event.currentTarget;

        const isFollowing = followButton.classList.contains("active");
        const followeeId = followButton.dataset.followeeId;

        const url = `/follows/${followeeId}`;
        const method = isFollowing ? "DELETE" : "POST";
        const headers = {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        };
        const options = {
            method: method,
            headers: headers
        };

        // Only add body for POST
        if (method === "POST") {
            headers["Content-Type"] = "application/json";
            options.body = JSON.stringify({ id: followeeId });
        }

        fetch(url, options)
        .then(response => response.json())
        .then(data => {
            if (data.status === "error") {
                alert(data.message)
            }
            else if (data.status === "followed") {
                followButton.classList.replace("gradient-text", "active");
                followButton.title = followButton.dataset.unfollowTitle;
                followButton.textContent = followButton.dataset.followingText;
            }
            else {
                followButton.classList.replace("active", "gradient-text");
                followButton.title = followButton.dataset.followTitle;
                followButton.textContent = followButton.dataset.followTitle;

            }
        })
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