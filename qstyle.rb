# Rails Application Template
#
# 2015/07/05
#
# FunnyQ

# 支援此 application template 相對位置的檔案操作
#===============================================================================
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# 加入安裝需要的 GEMS
#===============================================================================

# 移除舊版 sass-rails，改用 5.0.1，因為需要使用 susy2 and compass
gsub_file 'Gemfile', /.+'sass-rails'.+\n/, ''

# for test and development ENV
gem_group :development, :test do

  # RSpec
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "spring-commands-rspec"

  # Capybara 整合測試
  gem "capybara"
  gem "capybara-screenshot"

  # 使用 Guard 將開發流程的雜事自動化
  gem 'guard-livereload'
  gem 'guard-rspec', require: false
  gem 'guard-pow'

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
  gem 'capistrano', '~> 3.1.0'
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

  # 資料序列化工具（JSON）
  gem "active_model_serializers"

  # API 開發工具
  gem "grape"
  gem "grape-active_model_serializers"
  gem "grape-swagger-rails"

  # 支援跨站請求
  gem "rack-cors", require: "rack/cors"

end

# 前端相關
gem 'sprockets-rails'
gem 'sass-rails', '5.0.1'
gem 'compass-rails', '2.0.4'
gem 'bootstrap-sass'
gem 'font-awesome-sass'

gem 'bower-rails'
gem 'modernizr-rails'

if yes?('是否使用 React.js？（yes/no）')
  gem 'react-rails', '~> 1.0'
  gem 'sprockets-coffee-react'
end

# Debug 工具
gem 'awesome_rails_console'

# notifications
gem 'growlyflash', '0.6.2'
gem 'sweet-alert-confirm', '~> 0.1.0'
gem 'hipchat'

# App settings function
gem "rails-settings-cached", "0.4.1"
gem 'settingslogic'

# for View components and cache
gem 'cells', "~> 4.0.0.beta2"

# 檔案上傳與影像處理
gem 'carrierwave'
gem 'mini_magick'


if yes?("是否使用 Facebook oauth 登入 (yes/no)")
  gem "omniauth"
  gem "omniauth-facebook"
end

# 設定動作
#===============================================================================

after_bundle do

  # 將 bower 管理的前端套件路徑加入 assets pipeline
  environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components")'
  environment 'config.assets.precompile += %w(.svg .eot .woff .ttf .woff2 .otf)'

  # 將 i18n 預設語言設為 zh-TW
  environment 'config.i18n.default_locale = "zh-TW"'
  environment 'config.i18n.available_locales = [:"zh-TW"]'

  # 透過 Bower 安裝前端 lib
  copy_file 'Bowerfile'
  rake "bower:install"

  run "guard init"

  # 移除 test folder
  run "rm -rf test"

  # 使用建議的 ignore 設定
  remove_file '.gitignore'
  copy_file '.gitignore'

  # 建立資料庫
  rake 'db:create'
  rake 'db:migrate'

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
    copy_file   'vendor/_console_err.js'
  end

  # Sass
  inside 'app/assets/stylesheets' do
    remove_file 'application.css'
    copy_file 'application.css.sass'
    copy_file 'pages/_index.css.sass'
    copy_file 'partials/_color.css.sass'
    copy_file 'partials/_helper.css.sass'
    copy_file 'partials/_layout.css.sass'
    copy_file 'partials/_mixins.css.sass'
    copy_file 'partials/_typography.css.sass'
    copy_file 'partials/_variables.css.sass'
  end

  # View
  inside 'app/views' do
    remove_file 'layouts/application.html.erb'
    copy_file 'layouts/application.html.erb'
    copy_file 'common/_header.html.erb'
    copy_file 'common/_footer.html.erb'
    copy_file 'common/_ga.html.erb'
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

  # capistrano
  copy_file 'Capfile'

  inside 'config' do
    copy_file 'deploy.rb'
    copy_file 'deploy/production.rb'
  end

  file 'shared/config/application.yml', <<-CODE
# config/application.yml
defaults: &defaults
  mysql:
    database:
    password:
    username:
  secret_key: '' # `rake secret` to generate one

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
  secret_key: '' # `rake secret` to generate one
  CODE
  run 'rm config/application.yml'
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

production:
  <<: *default
  database: db/production.sqlite3
  CODE
  run 'rm config/database.yml'
  run 'ln shared/config/database.yml config/database.yml'

  file 'shared/config/secrets.yml', <<-CODE
development:
  secret_key_base: 4190de7294576817164261152b2a5d36d61ec6be54d336e514e15f662618df30bf3c33502853aa8c1321263bc4a90702c0205e110ee1f61f177cbfde9ae36a05

test:
  secret_key_base: b4a2beda7d4aef1b4555daa71b799d402fa4b7fc273095e125f1b6a2ed91ed84cae46a882de0b9970e7c8091f7c76b2e0568afef03fe9285600b026d15660cc0

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= Settings.secret_key %>
  CODE
  run 'rm config/secrets.yml'
  run 'ln shared/config/secrets.yml config/secrets.yml'

end


# git 初始化
#===============================================================================
after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
