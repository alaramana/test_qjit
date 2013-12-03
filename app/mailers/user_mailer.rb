class UserMailer < ActionMailer::Base
  default from: SMTPConfig.smtp_settings["from"]

  def send_user_invitation(user,sender)
    @user = user
    @sender = sender       

    mail :to => user.email, :subject => "User Signup"
  end
end
