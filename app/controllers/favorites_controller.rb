class FavoritesController < ApplicationController
  before_action :require_login!

  # POST users/:user_id/favorites/:post_type/:post_id
  def add_to_fav
     @favorite = Favorite.new(
    user_id: params[:user_id],
    post_id: params[:post_id],
    post_type: params[:post_type]
  )

    if @favorite.save
        render json: { status: "liked" }
    else
        render json: { status: "error", message: t("message.follow_error") }
    end
  end

  def remove_from_fav
     @favorite = Favorite.find_by(
        user_id: params[:user_id],
        post_id: params[:post_id],
        post_type: params[:post_type]
      )

      if @favorite.destroy
        render json: { status: "unliked" }
      else
        render json: { status: "error", message: t("message.follow_error") }
      end
  end
end
