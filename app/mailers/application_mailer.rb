class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("daothihaan@gmail.com", "Fotobook Team")
  layout "mailer"
end
