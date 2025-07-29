module PostsHelper
  def show_post_path(is_photo, post)
    if is_photo
      photo_path(post)
    else
      album_path(post)
    end
  end
end
