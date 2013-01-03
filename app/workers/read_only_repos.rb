class ReadOnlyRepos
  include Sidekiq::Worker

  def self.sync_repos
    perform_async
  end

  def perform
    github = Github.new basic_auth: ENV['GH_USERNAME'] + ':' + ENV['GH_PASSWORD']

    # Get the 'All Rackers' team
    teams = github.orgs.teams.list "rackspace"
    all_rackers = teams.find { |t| t["name"] == 'All Rackers' }

    repositories = github.repos.list :org => 'rackspace'
    logger.debug "There are #{repositories.count} repositories in the rackspace organization."

    repositories.each do |r|

      unless github.orgs.teams.team_repo?(all_rackers["id"], "rackspace", r["name"])
        github.orgs.teams.add_repo(all_rackers["id"], 'rackspace', r['name'])
        logger.info "Added repository #{r["name"]} to 'All Rackers' team in the rackspace organization."
      end
    end
  end
end