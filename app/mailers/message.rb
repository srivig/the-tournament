class Message < ActionMailer::Base
  default from: "info@notsobad.jp"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message.hello.subject
  #
  def hello
    @greeting = "Hi"

    mail to: "info@notsobad.jp", subject: 'Test Mail'
  end
end
