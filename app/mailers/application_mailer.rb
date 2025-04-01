class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SENDGRID_FROM")
  layout "mailer"
end
