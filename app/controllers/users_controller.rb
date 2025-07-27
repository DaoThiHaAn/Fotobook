class UsersController < ApplicationController
  def new
  end

  def create
  end


  def index
    render :index
  end

  def edit
    render :edit
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_registration_path, notice: t("message.update_success")
    else
      flash.now[:alert] = t("message.update_failed")
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :avatar
    )
  end
end
