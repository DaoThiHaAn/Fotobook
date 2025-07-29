class UsersController < ApplicationController
  before_action :require_login!, only: [ :edit, :update, :index ]
  before_action :select_user
  before_action -> { require_owner!(@user) }, except: [ :index ]

  def show
    @user = User.find(params[:id])
    @is_public = @user.profile.is_public
    @photos = @user.photos.order(created_at: :desc).page(params[:page]).per(12)
  end

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
      redirect_to edit_user_registration_path, alert: @user.errors.full_messages.join("<br>")
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :avatar
    )
  end

  def select_user
    @user = current_user
  end
end
