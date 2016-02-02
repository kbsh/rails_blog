class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :init

  def init
    @recommend_tags = Tag.recommend
    @liked_contents = Content.liked
    @latest_contents = Content.latest
  end
end
