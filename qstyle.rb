# Rails Application Template
#
# 2014/11/10
#
# FunnyQ

# 支援此 application template 相對位置的檔案操作
#===============================================================================
def source_paths
    [File.expand_path(File.dirname(__FILE__))]
end

# 加入安裝需要的 GEMS
#===============================================================================

# 移除舊版 sass-rails，改用 5.0.0.beta1，因為需要使用 susy2 and compass
gsub_file 'Gemfile', /.+'sass-rails'.+\n/, ''

# for test and development ENV
gem_group :development, :test do

  # RSpec 相關
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

  # Debug 工具
  gem "pry"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "pry-theme"

  # 取代 fixture 來製作假資料
  gem "factory_girl_rails"
  gem "database_cleaner"

  # Linter
  gem "rubocop"

end

# 使用者系統
gem "devise"

# API 開發工具組
if yes?("是否進行開發 API？ yes/no")

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
gem 'sprockets-rails', '3.0.0.beta1'
gem 'sass-rails', '5.0.0.beta1'
gem 'compass-rails', '2.0.0'

gem 'bower-rails'
gem 'modernizr-rails'

# 檔案上傳與影像處理
gem 'carrierwave'
gem 'mini_magick'

if yes?("是否使用 Facebook oauth登入")
  gem "omniauth"
  gem "omniauth-facebook"
  gem "auto-facebook", :github => "FunnyQ/auto-facebook"
end

# 設定動作
#===============================================================================

run "bundle"

# 將 bower 管理的前端套件路徑加入 assets pipeline
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components")'
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")'
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components","fontawesome","fonts")'

copy_file 'Bowerfile'

rake "bower:install"


run "guard init"

run "rm -rf test"

# 使用建議的 ignore 設定
remove_file '.gitignore'
copy_file '.gitignore'

# 建立資料庫
rake 'db:create'
rake 'db:migrate'

generate(:controller, "frontend")
route "resources :frontend, :only => [:index]"

file 'app/controllers/frontend_controller.rb', <<-CODE
  class FrontendController < ApplicationController

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
  copy_file   'vendor/_bootstrap.js'
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
  copy_file 'vendor/_bootstrap.scss'
  copy_file 'vendor/_bs_variables.scss'
end

# View
inside 'app/views' do
  remove_file 'layouts/application.html.erb'
  copy_file 'layouts/application.html.erb'
  copy_file 'partials/_header.html.erb'
  copy_file 'partials/_footer.html.erb'
  copy_file 'partials/_GA.html.erb'
  copy_file 'frontend/index.html.erb'
end



# git 初始化
#===============================================================================
git :init
git add: "."
git commit: "-m 'Initial commit'"
