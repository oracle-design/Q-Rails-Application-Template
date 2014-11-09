# Rails Application Template
#
# 2014/11/10
#
# FunnyQ


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
  gem "database-cleaner"

  # Linter
  gem "rubocop"

end

# 懶人後台
if yes?("是否使用懶人後台 activeadmin？")
  gem "activeadmin", github: "activeadmin"
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
