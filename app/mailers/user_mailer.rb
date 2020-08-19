class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".please_activate_your_account")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".please_reset_your_account")
  end
end
