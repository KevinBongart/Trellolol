require 'bundler/capistrano'
require "whenever/capistrano"

set :application, "Trellolol"
set :repository,  "http://github.com/KevinBongart/Trellolol.git"
set :user, "trellolol"
set :domain, "berman.challengepost.com"

set :keep_releases, 3

set :scm, :git
set :branch, :master
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

set :deploy_to, "/home/#{user}/#{application}"
set :current, "#{deploy_to}/current"
set :pid_file, "tmp/pids/server.pid"

role :web, domain
role :app, domain
role :db,  domain, :primary => true # This is where Rails migrations will run

set :use_sudo, false
set :whenever_command, "bundle exec whenever"

namespace :deploy do
  task :start do
    run "cd #{current} && bundle exec rails server --binding=127.0.0.1 --port=3001 --daemon --environment=production thin"
  end
  task :stop do
    # send KILL signal to process named ruby owned by user
    run "pkill -KILL -u #{user} ruby || echo 'It was just not running...'"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

namespace :assets do
  task :precompile do
    run "cd #{current} && RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

namespace :logs do
  task :watch do
    stream("tail -f #{deploy_to}/shared/log/production.log")
  end
end

before "deploy:start", "deploy:migrate"
before "deploy:start", "assets:precompile"
after "deploy:start", "deploy:cleanup"