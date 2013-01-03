# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/background.log"

every 5.minutes do
  runner "EdirPoller.update_feed"
end

every 1.day do
  runner "UnlinkedUsers.generate_report"
end

every 1.hour do
  runner "ReadOnlyRepos.sync_repos"
end



#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
