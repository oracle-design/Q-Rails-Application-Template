# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, Sittings.capistrano.app_name
set :repo_url, Sittings.capistrano.repo_url
set :deploy_to, Sittings.capistrano.deploy_to

set :linked_files, %w{config/database.yml}
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
# set :keep_releases, 5

# install bower components before assets precompile
before "deploy:assets:precompile", "bower:install"

namespace :bower do
  task :install do
    on roles(:app) do
      within release_path do
        execute :rake, 'bower:install'
      end
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
