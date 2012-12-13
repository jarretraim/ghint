class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.github_user.nil?
      redirect_to new_github_user_path
    end
  end
end
