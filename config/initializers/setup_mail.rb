ActionMailer::Base.smtp_settings = {
  :address              => SMTPConfig.smtp_settings["address"],
  :port                 => SMTPConfig.smtp_settings["port"],
  :domain               => SMTPConfig.smtp_settings["domain"],
  :user_name            => SMTPConfig.smtp_settings["user_name"],
  :password             => SMTPConfig.smtp_settings["password"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
