# typed: false
class UserMailer < ApplicationMailer
  def account_reset(email, raw)
    if Rails.env.development?
      base = "http://localhost:3000"
    else
      base = "https://web.makasu.co"
    end

    @reset_url = "#{base}/reset/?token=#{raw}"

    mail(to: email, subject: "Makasu Password Reset")
  end
end
