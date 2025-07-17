class AuthenticationController < ApplicationController
  def login
  end

  def handle_login
  end

  def logout
    session[:current_user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_url
  end

  def forgot_pw
  end
end
