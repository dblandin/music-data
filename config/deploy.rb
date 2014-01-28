set :application, 'music-data'
set :repo_url,    'git@github.com:dblandin/music-data.git'
set :branch,      'master'
set :deploy_via,  :remote_cache

set :deploy_to, '/var/www/music-data'
set :scm,                :git
set :git_shallow_clone,  1
set :format,             :pretty
set :log_level,          :debug
set :pty,                true
set :keep_releases,      1

set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}

namespace :deploy do
  unicorn_pidfile = "#{shared_path}/tmp/pids/unicorn.pid"
  env_file        = "#{shared_path}/.env"

  desc "Upload the environment file"
  task :dotenv do
    on roles(:app), in: :sequence do
      dotfile = fetch(:dotenv)

      upload!(dotfile, env_file) if File.exist?(dotfile)
    end
  end

  desc 'Start the application'
  task :start do
    on roles(:app), in: :sequence do
      execute "cd #{current_path} && source .env && bundle exec unicorn_rails -c config/unicorn.rb -E $RACK_ENV -D"
    end
  end

  desc 'Stop the application'
  task :stop do
    on roles(:app), in: :sequence do
      execute "if [ -f #{unicorn_pidfile} ]; then cd #{current_path} && kill -QUIT $(cat #{unicorn_pidfile}) | echo 'Unicorn is not running'; fi"
    end
  end

  desc 'Restart the application'
  task :restart do
    on roles(:app), in: :sequence do
      execute "if [ -f #{unicorn_pidfile} ]; then cd #{current_path} && kill -USR2 $(cat #{unicorn_pidfile}) | echo 'Unicorn is not running'; fi"
    end
  end

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate do
    on primary :db do
      execute "cd #{release_path} && source #{env_file} && bundle exec rake db:migrate"
    end
  end

  before 'check:linked_files', 'deploy:dotenv'

  after :finishing, 'deploy:cleanup'
end
namespace :sidekiq do
  sidekiq_pidfile = "#{shared_path}/tmp/pids/sidekiq.pid"
  env_file        = "#{shared_path}/.env"

  desc 'Start sidekiq'
  task :start do
    on roles(:app), in: :parallel do
      execute "cd #{current_path} && source #{env_file} && bundle exec sidekiq -d -i 0 -P #{sidekiq_pidfile} -e production -c $SIDEKIQ_WORKERS -q default -L #{current_path}/log/sidekiq.log"
    end
  end

  desc 'Stop sidekiq'
  task :stop do
    on roles(:app), in: :parallel do
      execute "if [ -f #{sidekiq_pidfile} ]; then cd #{current_path} && kill -TERM $(cat #{sidekiq_pidfile}) | echo 'Sidekiq is not running'; fi"
    end
  end
end
