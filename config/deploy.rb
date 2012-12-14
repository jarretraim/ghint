set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

require 'rvm/capistrano'
require 'bundler/capistrano'
load 'deploy/assets'

set :application, "ghint"
set :repository,  "git://github.com/jarretraim/ghint.git"
set :scm, :git

set :use_sudo, false
set :user, "ghint"
set :scm_username, "jarretraim"
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "ghint_id_rsa")]

default_run_options[:pty] = true

set :deploy_to, "/opt/ghint"
server "github-integration.inova.dfw1.us.ci.rackspace.net", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :symlink_shared do
    run "ln -s #{shared_path}/local_env.yml #{release_path}/config/"
  end
end

after "deploy:update", "deploy:symlink_shared"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end