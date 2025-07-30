module PostsHelper
  def show_post_path(is_photo, post)
    if is_photo
      photo_path(post)
    else
      album_path(post)
    end
  end

  def show_upload_btn_album(resource)
    if resource.persisted?
      resource.photos_count < 25 ? "d-flex" : "d-none"
    else
      "d-flex"
    end
  end
end
