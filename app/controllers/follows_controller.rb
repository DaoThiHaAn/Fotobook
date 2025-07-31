class FollowsController < ApplicationController
  before_action :require_login!

  # create A follows B
  def create
    @follow = current_user.profile.follows.build(followee_id: params[:followee_id])
    if @follow.save
      render json: { status: "followed" }
    else
      render json: { status: "error", message: t("message.follow_error") }
    end
  end

  # destroy A follows B
  def destroy
    @follow = current_user.profile.follows.find_by(followee_id: params[:followee_id])
    if @follow&.destroy  # call destroy if not nil
      render json: { status: "unfollowed" }
    else
      render json: { status: "error", message: t("message.follow_error") }
    end
  end
end
