module ProfilesHelper
    # Authorization for 4 link tabs in profile page
    def profile_photo_tab(is_public, count: 0)
        path = is_public ? profile_photos_path(params[:profile_id]) : index_user_photos_path(current_user.id)
        tab_class = "profile-tab-btn text-uppercase #{highlight_active_tab("photos")}"

        link_to path, class: tab_class do
            content_tag(:p, count.to_s, class: "m-0 number") + t("button.photo", count: count)
        end
    end

    def profile_album_tab(is_public, count: 0)
        path = is_public ? profile_albums_path(params[:profile_id]) : index_user_albums_path(current_user.id)
        tab_class = "profile-tab-btn text-uppercase #{highlight_active_tab("albums")}"

        link_to path, class: tab_class do
            content_tag(:p, count.to_s, class: "m-0 number") + t("button.album", count: count)
        end
    end

    def profile_follower_tab(is_public, count: 0)
        path = is_public ? profile_followers_path(params[:profile_id]) : user_followers_path(current_user.id)
        tab_class = "profile-tab-btn text-uppercase #{highlight_active_tab("followers")}"

        link_to path, class: tab_class do
            content_tag(:p, count.to_s, class: "m-0 number") + t("button.follower", count: count)
        end
    end

    def profile_following_tab(is_public, count: 0)
        path = is_public ? profile_followings_path(params[:profile_id]) : user_followings_path(current_user.id)
        tab_class = "profile-tab-btn text-uppercase #{highlight_active_tab("followings")}"

        link_to path, class: tab_class do
            content_tag(:p, count.to_s, class: "m-0 number") + t("button.following", count: count)
        end
    end

    def check_follow(person1, person2) # expect Profile obj
      Follow.exists?(follower_id: person1.user_id, followee_id: person2.user_id)
    end
end
