class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(
    ENV.fetch("EMAIL_FROM_ADDRESS", "EMAIL_FROM_ADDRESS"),
    ENV.fetch("EMAIL_FROM_NAME", "EMAIL_FROM_NAME")
  )
  layout "mailer"
end
