class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(
    ENV.fetch("SENDGRID_FROM_EMAIL", "SENDGRID_FROM_EMAIL"),
    ENV.fetch("SENDGRID_FROM_NAME", "SENDGRID_FROM_NAME")
  )
  layout "mailer"
end
