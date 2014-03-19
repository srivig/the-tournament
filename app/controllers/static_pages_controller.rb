class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def about
    render layout: 'about'
  end

  def top
    @tournaments = Tournament.limit(5)
  end
end
