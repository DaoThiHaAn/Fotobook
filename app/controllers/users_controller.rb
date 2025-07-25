class UsersController < ApplicationController
  layout "devise", only: [:edit]

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
  end

  def sign_up_params
    params.require(resource_name).permit(:email, :password, :password_confirmation, :fname, :l) # Add your custom fields
  end

end
