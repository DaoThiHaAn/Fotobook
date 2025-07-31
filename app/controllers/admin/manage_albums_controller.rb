module Admin
  class ManageAlbumsController < ApplicationController
    def index
      @albums = Album.includes(:photos).all.order(updated_at: :desc).page(params[:page]).per(40)
    end

    def edit
      @album = Album.find(params[:id])
    end

    def update
      @album = Album.find(params[:id])
      if @album.update(params.require(:album).permit(:title, :description, :is_public))
        # Update photos if any
        files = params[:album][:image_path].reject { |f| f.blank? }
        if files.any?
          # Remove existing photos and add new ones
          @album.album_components.destroy_all
          files.each do |uploaded_file|
            photo = Photo.create!(
              title: @album.title, # or set a default/blank title
              description: @album.description, # or blank
              image_path: uploaded_file,
              is_public: @album.is_public,
              user_id: current_user.id
            )
            AlbumComponent.create!(album: @album, photo: photo)
          end
        end
        redirect_to admin_albums_path, notice: t("message.album_updated")
      else
        render :edit, status: :unprocessable_entity, alert: t("message.album_updated_failed")
      end
    end

    def destroy
      if @album.destroy
        redirect_to admin_albums_path, notice: t("message.album_deleted")
      else
        render :edit, status: :unprocessable_entity, alert: t("message.album_deleted_failed")
      end
    end
  end
end
