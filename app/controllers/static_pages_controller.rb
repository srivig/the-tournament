class StaticPagesController < ApplicationController
  def about
    render layout: 'about'
  end

  def top
    @tournaments = Tournament.limit(10)
  end
end
