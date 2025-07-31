module Admin
  class ManagePhotosController < ApplicationController
    def index
        @photos = Photo.all.order(updated_at: :desc).page(params[:page]).per(40)
    end
  end
end
