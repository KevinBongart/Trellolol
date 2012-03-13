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

role :web, domain
role :app, domain
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :use_sudo, false

namespace :deploy do
  task :start do
    run "nohup bundle exec rails s -p 3001"
  end
  task :stop do
    run "kill -KILL `cat tmp/pids/server.pid`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

namespace :logs do
  task :watch do
    stream("tail -f #{deploy_to}/shared/log/production.log")
  end
end

after "deploy", "deploy:migrate"
