module Admin
  class ManageAlbumsController < ApplicationController
    def index
      @albums = Album.includes(:photos).all.order(updated_at: :desc).page(params[:page]).per(40)
    end
  end
end
