module ApplicationHelper
    def formatted_name(user)
        # Format: An B. C. Dao Thi Ha
        fname_array = user.first_name.split
        lname_array = user.last_name.split
        fname = fname_array.shift.capitalize

        fname_array = fname_array.map { |word|
            word[0].upcase + "."
        }

        lname_array = lname_array.map { |word| word.capitalize }

        "#{fname} #{fname_array.join(' ')} #{lname_array.join(' ')}"
    end

    def style_avatar(user)
        # TODO: check avatar is nil by carrierwave method
        if user.avatar.file.nil?
            "fake"
        end
    end

    def highlight_active_tab(tab_name)
        if params[tab_name.to_sym].present? || request.fullpath.include?(tab_name)
            "active"
        else
            ""
        end
    end

    # Authorization for 4 link tabs in profile page
    def profile_photo_tab(is_public, count: 0)
        path = is_public ? profile_photos_path(params[:profile_id]) : index_user_photos_path(current_user.id)
        tab_class = "profile-tab-btn text-uppercase #{highlight_active_tab("photos")}"

        link_to path, class: tab_class do
            content_tag(:p, count.to_s, class: "m-0 number") + t("button.photo", count: count)
        end
    end
end
