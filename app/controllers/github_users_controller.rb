class GithubUsersController < ApplicationController

  def show
    @gh_user = current_user.github_user
  end

  def destroy
    current_user.github_user.delete
    redirect_to :action => 'new'
  end

  def redirect
    github = Github.new :client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET']
    token = github.get_token(params[:code])
    logger.debug "Token: #{token.token}"

    github = Github.new oauth_token: token.token
    user = github.users.get

    g = GithubUser.where(:login => user[:login]).first_or_create do |gh_user|
      gh_user.gh_id = user[:id]
      gh_user.url = user[:url]
      gh_user.html_url = user[:html_url]
      gh_user.name = user[:name]
      gh_user.location = user[:location]
      gh_user.email = user[:email]
      gh_user.gh_created_at = user[:created_at]
      gh_user.public_repos = user[:public_repos]
      gh_user.private_repos = user[:total_private_repos]
      gh_user.avatar_url = user[:avatar_url]
      gh_user.user = current_user
      gh_user.save
    end

    # Add the user to the standard 'All Rackers group'
    AddUser.add current_user.username

    flash[:notice] = "Your Github and Rackspace accounts are now linked. Your account will now be added to the 'All Rackers' group in Github."
    redirect_to :action => 'show', :id => g.id
  end

  def new
    github = Github.new :client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET']
    @gh_uri = github.authorize_url :scope => 'user'
  end

end
