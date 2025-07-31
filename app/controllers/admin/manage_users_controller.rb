module Admin
  class ManageUsersController < ApplicationController
    before_action :require_admin!
    def index
      @users =  User.where(is_admin: false).order(:id).page(params[:page]).per(10)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        if @user.is_active
          # send email to user
          UserMailer.with(user: @user).update_profile_email.deliver_later
        else
          UserMailer.with(user: @user).inactive_profile_email.deliver_later
        end
        redirect_to admin_users_path, notice: t("message.update_success")
      else
        flash.now[:alert] = t("message.update_failed")
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @email = @user.email
      @user.destroy
      UserMailer.with(email: @email).delete_profile_email.deliver_later
      redirect_to admin_users_path, notice: t("message.delete_acc_success")
    end

  private
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :avatar, :email, :is_active
    )
  end
  end
end
