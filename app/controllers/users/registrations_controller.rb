class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    # GAにイベントを送信
    flash[:log] = "<script>ga('send', 'event', 'user', 'registration');</script>".html_safe
    super
  end
end
