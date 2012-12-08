class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @gh_vars = {
        :client_id => ENV['GH_CLIENT_ID'],
        :redirect_uri => "http://localhost:3000/redirect",
        :scope => "user",
        :state => SecureRandom.uuid
    }

    github = Github.new :client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET']
    @gh_uri = github.authorize_url :scope => 'user'

    #@gh_uri = "https://github.com/login/oauth/authorize?" + @gh_vars.to_query
  end

  def redirect
    github = Github.new :client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET']
    token = github.get_token(params[:code])
    logger.debug "Token: #{token.token}"

    github = Github.new oauth_token: token.token
    user = github.users.get

    GithubUser.where(:login => user[:login]).first_or_create do |gh_user|
      gh_user.gh_id = user[:id]
      gh_user.url = user[:url]
      gh_user.html_url = user[:html_url]
      gh_user.name = user[:name]
      gh_user.location = user[:location]
      gh_user.email = user[:email]
      gh_user.gh_created_at = user[:created_at]
      gh_user.public_repos = user[:public_repos]
      gh_user.private_repos = user[:total_private_repos]
      gh_user.user = current_user
      gh_user.save
    end

    redirect_to root_url
  end
end
