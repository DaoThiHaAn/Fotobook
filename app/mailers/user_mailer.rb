class UserMailer < ApplicationMailer
  default from: email_address_with_name("daothihaan@gmail.com", "Fotobook Team")

  def welcome_email
    @user = User.current_user
    @root_url = Rails.application.routes.url_helpers.root_url
    mail(
      to: @user.email
      subject: "Welcome to Fotobook"
    )

end
