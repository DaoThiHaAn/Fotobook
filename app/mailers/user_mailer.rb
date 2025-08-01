class UserMailer < ApplicationMailer
  def update_profile_email
    @user = params[:user]
    mail(
      to: @user.email,
      subject: "FOTOBOOK ACCOUNT UPDATED BY ADMIN",
      template_name: "profile_update_email"
    )
  end

  def inactive_profile_email
    @user = params[:user]
    mail(
      to: @user.email,
      subject: "FOTOBOOK ACCOUNT INACTIVE",
      template_name: "profile_inactive_email"
    )
  end

  def delete_profile_email
    @email = params[:email]
    mail(
      to: @email,
      subject: "FOTOBOOK ACCOUNT DELETED",
      template_name: "profile_delete_email"
    )
  end
end
