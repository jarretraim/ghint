#
# Adds a user to the standard 'All Rackers' team in github
#
class AddUser
  include Sidekiq::Worker

  def self.add(sso)
    perform_async sso
  end

  def perform(sso)
    user = User.find_by_username(sso)

    # Don't know the user at all
    if user.nil?
      logger.error "SSO #{sso} is not a known Ghint user - can't be added to the 'All Rackers' group."
      return
    end

    # User logged in, but didn't associate a GH account
    if user.github_user.nil?
      logger.error "SSO #{sso} is not mapped to a user in Ghint - no user to add."
      return
    end

    gh_login = user.github_user.login

    github = Github.new basic_auth: ENV['GH_USERNAME'] + ':' + ENV['GH_PASSWORD']

    # 307676 is the id for the 'All Rackers' team in the 'rackspace' organization
    github.organizations.teams.add_member 307676, gh_login
    logger.info "Github user #{gh_login} has been added to the 'All Rackers' group in Github."
  end
end