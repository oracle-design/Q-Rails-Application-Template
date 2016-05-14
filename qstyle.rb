# Rails Application Template
#
# 2015/07/05
#
# FunnyQ

# 支援此 application template 相對位置的檔案操作
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# clean file
run 'rm README.rdoc'

# 加入安裝需要的 GEMS

# 移除舊版 sass-rails，改用 5.0.1，因為需要使用 susy2 and compass
gsub_file 'Gemfile', /.+'sass-rails'.+\n/, ''

# for test and development ENV
gem_group :development, :test do

  # RSpec
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "spring-commands-rspec"

  # Time Mock
  gem 'timecop'

  # Capybara 整合測試
  gem "capybara"
  gem "capybara-screenshot"

  # 使用 Guard 將開發流程的雜事自動化
  gem 'guard-livereload'
  gem 'guard-rspec', require: false
  gem 'guard-pow'
  gem 'terminal-notifier-guard'

  # 在 model 檔案中註釋 schema
  gem 'annotate'

  # 增強錯誤畫面
  gem "better_errors"

  # 支援 chrome 的 rails panel
  gem "meta_request"

  # 移除 log 中不必要的部份
  gem "quiet_assets"

  # 取代 fixture 來製作假資料
  gem "factory_girl_rails"
  gem "database_cleaner"

  # Linter
  gem "rubocop"

  # 偵測 N+1 問題
  gem 'bullet'

  # Deploy 工具
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
  gem 'slackistrano', require: false
end

# mysql adapter
gem 'mysql2'

# 使用者系統
gem "devise"

# API 開發工具組
if yes?("是否進行開發 API？ (yes/no)")

  # API 開發工具
  gem "grape"
  gem 'grape-entity'
  gem "grape-swagger-rails"

  # 跨站請求
  gem "rack-cors", require: "rack/cors"

end

# 前端相關
gem 'sprockets-rails'
gem 'sass-rails'
gem 'font-awesome-sass'
gem 'sassc-rails'
gem 'bourbon'
gem 'neat'
if yes?('是否安裝 bootstrap-sass gem？（yes/no）')
  gem 'bootstrap-sass'
end

gem 'bower-rails'
gem 'modernizr-rails'

if yes?('是否使用 React.js？（yes/no）')
  gem 'react-rails', '~> 1.0'
  gem 'sprockets-coffee-react'
end

# Debug 工具
gem 'awesome_rails_console'

# notifications
gem 'growlyflash'
gem 'sweet-alert'
gem 'sweet-alert-confirm'

# App settings function
gem "rails-settings-cached", "0.4.1"
gem 'settingslogic'

# for View components and cache
gem 'cells'
gem 'cells-erb'

# 檔案上傳與影像處理
gem 'carrierwave'
gem 'mini_magick'

# SEO
gem 'meta-tags'

# 權限管理
gem "pundit"

if yes?("是否使用 Facebook oauth 登入 (yes/no)")
  gem "omniauth"
  gem "omniauth-facebook"
  gem "koala", "~> 2.2"
end

# 設定動作
#===============================================================================

after_bundle do

  application  do
    %q{
      # Set bower components path and precompile type
      config.assets.paths << Rails.root.join("vendor","assets","bower_components")
      config.assets.precompile += %w(.svg .eot .woff .ttf .woff2 .otf)

      # Set timezone
      config.time_zone = 'Taipei'
      config.active_record.default_timezone = :local

      # Set locale
      config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
      config.i18n.default_locale = "zh-TW"
      config.i18n.available_locales = [:"zh-TW", :en]

      # Set generator
      config.generators do |g|
        g.orm :active_record
        g.view_specs false
        g.routing_specs false
        g.helper_specs false
        g.request_specs false
        g.assets false
        g.helper false
      end
    }
  end

  # # 將 bower 管理的前端套件路徑加入 assets pipeline
  # environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components")'
  # environment 'config.assets.precompile += %w(.svg .eot .woff .ttf .woff2 .otf)'

  # # Set timezone
  # environment 'config.time_zone = "Taipei"'
  # environment 'config.active_record.default_timezone = :local'

  # # 將 i18n 預設語言設為 zh-TW
  # environment 'config.i18n.default_locale = "zh-TW"'
  # environment 'config.i18n.available_locales = [:"zh-TW", :en]'

  # # 預設不產生 assets 檔案
  # environment 'config.generators.assets = false'

  # 透過 Bower 安裝前端 lib
  copy_file 'Bowerfile'
  run 'bundle exec rake bower:install'

  # 安裝 Rspec
  generate 'rspec:install'

  insert_into_file 'spec/rails_helper.rb',%(
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :webmock
    c.allow_http_connections_when_no_cassette = true
  end
  ), after: 'RSpec.configure do |config|'

  insert_into_file 'spec/rails_helper.rb', "\nrequire 'capybara/rails'", after: "require 'rspec/rails'"

  copy_file '.rubocop.yml'

  run "bundle exec guard init"

  # 移除 test folder
  run "rm -rf test"

  # 使用建議的 ignore 設定
  remove_file '.gitignore'
  file '.gitignore', <<-CODE
################################################################################
## 參考 https://github.com/github/gitignore/blob/master/Rails.gitignore       ##
################################################################################

*.rbc
capybara-*.html
.rspec
/log
/tmp
/db/*.sqlite3
/public/system
/public/uploads
/public/assets/ckeditor
/coverage/
/spec/tmp
**.orig
rerun.txt
pickle-email-*.html

# TODO Comment out these rules if you are OK with secrets being uploaded to the repo
/config/initializers/secret_token.rb
/config/secrets.yml
/config/application.yml
/config/database.yml
/shared/

## Environment normalisation:
/.bundle
/vendor/bundle

# these should all be checked in to normalise the environment:
# Gemfile.lock, .ruby-version, .ruby-gemset

# unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
.rvmrc

# if using bower-rails ignore default bower_components path bower.json files
/vendor/assets/bower_components
*.bowerrc
bower.json

################################################################################
## 參考 https://github.com/github/gitignore/blob/master/Ruby.gitignore        ##
################################################################################


*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/test/tmp/
/test/version_tmp/
/tmp/

## Specific to RubyMotion:
.dat*
.repl_history
build/

## Documentation cache and generated files:
/.yardoc/
/_yardoc/
/doc/
/rdoc/
  CODE

  # 建立資料庫
  run 'bundle exec rake db:create'
  run 'bundle exec rake db:migrate'

  # 建立 prototype controller for prototyping
  route "root 'prototype#index'"

  file 'app/controllers/prototype_controller.rb', <<-CODE
class PrototypeController < ApplicationController

  def index
  end

end
  CODE

  # 前端基本環境建立
  #===============================================================================

  # Javascript
  inside 'app/assets/javascripts' do
    remove_file 'application.js'
    copy_file   'application.js.coffee'
    copy_file   '_plugins.js.coffee'
    copy_file   '_app-base.js.coffee'
    copy_file   '_flash-style.js.coffee'
    copy_file   'vendor/_console_err.js'
    copy_file   'classes/.js_objects'
  end

  # Sass
  inside 'app/assets/stylesheets' do
    remove_file 'application.css'
    copy_file 'application.css.sass'
    copy_file 'pages/_index.css.sass'
    copy_file 'base/_base.scss'
    copy_file 'base/_buttons.scss'
    copy_file 'base/_forms.scss'
    copy_file 'base/_grid-settings.scss'
    copy_file 'base/_helpers.sass'
    copy_file 'base/_layout.sass'
    copy_file 'base/_lists.scss'
    copy_file 'base/_mixins.sass'
    copy_file 'base/_tables.scss'
    copy_file 'base/_typography.scss'
    copy_file 'base/_variables.scss'
  end

  # Helper
  inside 'app/helpers' do
    remove_file 'application_helper.rb'
    copy_file 'application_helper.rb'
  end

  # View
  inside 'app/views' do
    remove_file 'layouts/application.html.erb'
    copy_file 'layouts/application.html.erb'
    copy_file 'common/_header.html.erb'
    copy_file 'common/_footer.html.erb'
    copy_file 'prototype/index.html.erb'
  end

  # 其他設定
  #===============================================================================

  # SittingsLogic & i18n
  inside 'app/models' do
    copy_file 'settings.rb'
  end

  inside 'config' do
    copy_file 'locales/zh-TW.yml'
  end

  # adding staging env"
  copy_file 'config/environments/staging.rb'

  # setting up Bullet
  insert_into_file "config/environments/development.rb", :after => "# config.action_view.raise_on_missing_translations = true" do
"
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
  end
"
  end

  # capistrano
  copy_file 'Capfile'

  inside 'config' do
    copy_file 'deploy.rb'
    copy_file 'deploy/production.rb'
    copy_file 'deploy/staging.rb'
  end

  file 'shared/config/application.yml', <<-CODE
# config/application.yml
defaults: &defaults
  mysql:
    database:
    password:
    username:
  secret_key: '4190de7294576817164261152b2a5d36d61ec6be54d336e514e15f662618df30bf3c33502853aa8c1321263bc4a90702c0205e110ee1f61f177cbfde9ae36a05'

development:
  <<: *defaults

test:
  <<: *defaults

staging:
  <<: *defaults
  secret_key: '' # `rake secret` to generate one

production:
  <<: *defaults
  secret_key: '' # `rake secret` to generate one
  CODE

  run 'ln shared/config/application.yml config/application.yml'

  file 'shared/config/database.yml', <<-CODE
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

  # adapter: mysql2
  # encoding: utf8
  # database: <%= Settings.mysql.database %>
  # username: <%= Settings.mysql.username %>
  # password: <%= Settings.mysql.password %>
  # host: 127.0.0.1
  # port: 3306

development:
  <<: *default
  database: db/development.sqlite3


# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: db/test.sqlite3

staging:
  <<: *default
  database: db/staging.sqlite3

production:
  <<: *default
  database: db/production.sqlite3
  CODE

  run 'rm config/database.yml'
  run 'ln shared/config/database.yml config/database.yml'

  file 'shared/config/secrets.yml', <<-CODE
development:
  secret_key_base: <%= Settings.secret_key %>

test:
  secret_key_base: <%= Settings.secret_key %>

staging:
  secret_key_base: <%= Settings.secret_key %>

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= Settings.secret_key %>
  CODE
  run 'rm config/secrets.yml'
  run 'ln shared/config/secrets.yml config/secrets.yml'

  # 詢問是否安裝 Devise
  if yes?("要不要順便幫你安裝 Devise？(yes/no)")
    generate "devise:install"
    model_name = ask("你的使用者 model 名稱要設定為？ [預設為 user]")
    model_name = "user" if model_name.blank?
    generate "devise", model_name
  end

end




# git 初始化
#===============================================================================
after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
