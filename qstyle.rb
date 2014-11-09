# Rails Application Template
#
# 2014/11/10
#
# FunnyQ

def source_paths
    [File.expand_path(File.dirname(__FILE__))]
end

################################################################################
# 加入安裝需要的 GEMS
################################################################################

# for test and development ENV
gem_group :development, :test do

  if yes?("要不要來寫個測試？")
    gem "rspec-rails"
    gem "shoulda-matchers"
    gem "spring-commands-rspec"

    # 整合測試
    gem "capybara"
    gem "capybara-screenshot"
    gem "capybara-webkit"

  end

  # 自動更新瀏覽器
  gem 'guard-livereload'

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
  gem "factor"
  gem "database_cleaner"

  # Linter
  gem "rubocop"

end

# 懶人後台
if yes?("是否使用懶人後台 activeadmin？")
  gem 'activeadmin', github: 'activeadmin'
end

# 使用者系統
gem "devise"

# API 開發工具組
if yes?("是否進行開發 API？")

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
gem 'compass-rails'
gem 'bower-rails'
gem 'modernizr-rails'

# 檔案上傳與影像處理
gem 'carrierwave'
gem 'mini_magick'


################################################################################
# 設定動作
################################################################################

# 將 bower 管理的前端套件路徑加入 assets pipeline
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components")'
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")'
environment 'config.assets.paths << Rails.root.join("vendor","assets","bower_components","fontawesome","fonts")'

copy_file 'Bowerfile'

rake "bower:install"

# 使用建議的 ignore 設定
remove_file '.gitignore'
copy_file '.gitignore'

# 建立資料庫
rake 'db:create'
rake 'db:migrate'

################################################################################
# git 初始化
################################################################################

git :init
git add: "."
git commit: "-a -m 'Initial commit'"
