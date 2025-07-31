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

        const url = "/follows";
        const method = isFollowing ? "DELETE" : "POST";
        const body = JSON.stringify({ followee_id: followeeId });

        fetch(url, {
            method: method,
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content  // rails need this token for non-GET method
            },
            body: body
        })
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