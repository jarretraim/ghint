class RemoveUser
  include Sidekiq::Worker

  def self.remove(sso)
    perform_async sso
  end

  def perform(sso)
    user = User.find_by_username(sso)

    # Don't konw the user at all
    if user.nil?
      logger.error "SSO #{sso} is not a known Ghint user."
      return
    end

    # User logged in, but didn't associate a GH account
    if user.github_user.nil?
      logger.error "SSO #{sso} is not mapped to a user in Ghint - nothing to remove."
      return
    end

    gh_login = user.github_user.login

    github = Github.new basic_auth: ENV['GH_USERNAME'] + ':' + ENV['GH_PASSWORD']

    if github.organizations.members.member? 'rackspace', gh_login
      logger.debug "User #{sso} is a member of the rackspace organization as #{gh_login}"

      github.organizations.members.remove 'rackspace', gh_login
      logger.info "Github user #{gh_login} has been removed from the rackspace organization."
    else
      logger.info "User #{sso} is NOT a member of the rackspace organization as #{gh_login}"
    end

  end
end