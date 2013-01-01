class RemoveUser
  include Sidekiq::Worker

  def self.remove(sso)
    perform_async sso
  end

  def perform(sso)
    puts "Attempting to remove #{sso} from GitHub access."

    user = User.find_by_username(sso)

    if user.nil? || user.github_user.nil?
      puts "ERROR: SSO #{sso} is not mapped to a user in Ghint - nothing to remove."
      return
    end

    gh_login = user.github_user.login

    github = Github.new basic_auth: ENV['GH_USERNAME'] + ':' + ENV['GH_PASSWORD']

    if github.organizations.members.member? 'rackspace', gh_login
      puts "User #{sso} is a member of the rackspace organization as #{gh_login}"

      github.organizations.members.remove 'rackspace', gh_login
      puts "Github user #{gh_login} has been removed from the rackspace organization."
    else
      puts "User #{sso} is NOT a member of the rackspace organization as #{gh_login}"
    end

  end
end