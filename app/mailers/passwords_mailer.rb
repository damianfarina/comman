class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Reestablecer la contraseña", to: user.email_address
  end
end
