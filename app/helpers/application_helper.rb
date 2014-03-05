module ApplicationHelper
  def profile_img(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    img_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(img_url, alt: user.email, class: 'img-circle')
  end

  def panelheading(i)
    {class: "panel-danger"}
  end
end
