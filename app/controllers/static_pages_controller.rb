class StaticPagesController < ApplicationController
  layout 'about', except: [:index, :show]
  def about
  end

  def index
  end

  def show
  end
end
