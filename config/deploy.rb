# config valid only for Capistrano 3.1
lock '~>3.4.0'

set :application, 'AppName'
set :repo_url, 'git@github.com:USERNAME/REPONAME.git'
set :deploy_to, '/home/USERNAME/PATH_HERE'

set :linked_files, %w(config/database.yml)
set :linked_files, %w(config/database.yml config/application.yml config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)

# Default value for keep_releases is 5
# set :keep_releases, 5

# Slack integration
set :slack_webhook, 'https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXX'
set :slack_team, 'XXXXXXXXX'

set :slack_icon_url,         -> { 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
set :slack_icon_emoji,       -> { ':shipit:' } # will override icon_url, Must be a string (ex: ':shipit:')
set :slack_channel,          -> { '#deploy-notification' }
set :slack_username,         -> { 'Deploy-Bot' }
set :slack_run_starting,     -> { true }
set :slack_run_finished,     -> { true }
set :slack_msg_updating,     -> { ":rocket: #{ENV['USER'] || ENV['USERNAME']} 正在進行一個...部署的...動作，正在將 #{fetch :application} 的 #{fetch :branch} 分支部署到 Production :computer:" }
set :slack_msg_updated,     -> { ":pray: #{fetch :application} 部署成功，#{ENV['USER'] || ENV['USERNAME']} 好棒棒 :kissing_heart:" }
set :slack_fields_updated, [
  {
    title: "專案名稱",
    value: "#{fetch(:application)}",
    short: true
  },
  {
    title: "環境",
    value: fetch(:stage),
    short: true
  },
  {
    title: "部署者",
    value: fetch(:slack_deploy_user),
    short: true
  }
]

set :slack_msg_failed,       -> { ":shit: #{fetch :application} 部署失敗，我覺得 #{ENV['USER'] || ENV['USERNAME']} 你還是快去檢查 Log 吧？ :no_good:" }

Rake::Task['deploy:compile_assets'].clear

namespace :deploy do
  desc 'Compile assets'
  task compile_assets: [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    desc 'Precompile assets locally and then rsync to web servers'
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # rsync to each server
      local_dir = './public/assets/'
      on roles(fetch(:assets_roles, [:web])) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"

        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
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
