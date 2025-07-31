module Admin
  class ManagePhotosController < ApplicationController
    before_action :require_admin!

    def index
        @photos = Photo.all.order(updated_at: :desc).page(params[:page]).per(40)
    end

    def edit
      @photo = Photo.find(params[:id])
    end

    def update
      @photo = Photo.find(params[:id])
      if @photo.update(params.require(:photo).permit(:image_path, :title, :description, :is_public))
        redirect_to admin_photos_path, notice: t("message.photo_updated")
      else
        flash.now[:alert] = t("message.photo_updated_failed")
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @photo = Photo.find(params.expect(:id))
      if @photo.destroy
        removed_count = remove_empty_albums # returns how many were removed
        flash[:notice] = t("message.photo_deleted")
        if removed_count > 0
          flash[:notice] += "<br>#{removed_count} empty album#{'s' if removed_count > 1} removed."
        end
        redirect_to admin_photos_path
      else
          flash.now[:alert] = t("message.photo_deleted_failed")
          render :edit, status: :unprocessable_entity
      end
    end

    private
    def remove_empty_albums
      @empty_albums = Album.where(photos_count: 0)
      count = @empty_albums.count
      @empty_albums.destroy_all if @empty_albums.any?
      count
    end
  end
end
