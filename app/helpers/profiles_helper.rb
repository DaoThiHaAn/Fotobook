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
end
