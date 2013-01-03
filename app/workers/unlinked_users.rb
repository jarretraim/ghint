class UnlinkedUsers
  include Sidekiq::Worker

  def self.generate_report
    perform_async
  end

  def perform
    github = Github.new basic_auth: ENV['GH_USERNAME'] + ':' + ENV['GH_PASSWORD']

    members = github.organizations.members.list 'rackspace'
    logger.debug "There are #{members.count} users in the rackspace organization"

    unlinked_users = []

    members.each do |m|
      linked_user = GithubUser.find_by_gh_id m["id"]

      if linked_user.nil?
        gh_user = github.users.get m["login"]
        unlinked_users << { :login => m["login"], :id => m["id"], :name => gh_user["name"] }
      end
    end

    logger.info "There are #{unlinked_users.count} unlinked users out of #{members.count} total users in the rackspace organization."
  end
end