# Rails Application Template

建立 rails 專案時的初始樣板。使用 bower 作為前端套件的管理工具，因此系統必須事先安裝 node.js 與 bower。

## 使用方法

```sh
rails new example -m https://raw.githubusercontent.com/oracle-design/Q-Rails-Application-Template/master/qstyle.rb
```

（必須事先安裝 node.js，建議使用 nvm 或 ndenv。)

## 更新

**2016-05-12**

- 關閉單行長度的 style 檢查
- 更新 Readme
- 更新 rspec 相關設定
- 修正 sweet-alert gem 造成的問題

**2016-05-12**

- 更新 rubocop 設定
- 更新 capistrano 設定
- 更新 Template 部分寫法
- 改用 get 從網路上取得檔案

**2016-02-26**

- 新增 `terminal-notifier-guard` 以提示目前的測試結果
- 新增 `bourbon` 和 `neat` 取代 `compass`
- 更新 `growlyflash` 版本
- 使用 `sweet-alert` 取代 rails-asset 版本
- 移除 `simple_enum`，未來一律使用 rails 內建的 enum 功能
- 使用 `bitters` 提供的 base CSS 設定取代原本的 partials 內容（目前版本為 `bitters 1.2.0`，有部分自訂內容）
- 移除 `application.sass` 中 assets pipeline 提供的 require 功能，改用 sass 的 import
- 使用 `sanitize-css` 做 CSS reset，並將字體預設大小訂為 16px
- 新增 flash 的自訂樣式設定在 javascripts 中（`flash-style`）

**2015-09-30**

- 增加 koala 和 cells-erb
- 更新 sweet-alert-confirm
- 預設不產生 assets 檔案
- 自動執行 rspec:install
- 增加 `.rubocop.yml` 檔案
- 新增 'grape-entity' 取代 serializer

**2015-09-30**

- 增加 classes 資料夾 for coffeeScript class
- 增加 simple_enum 和 pundit gem
- 增加 image_placeholder helper

**2015-09-02**

- 增加 Staging ENV 設定
- 可自動安裝與產生 Devise model
- 自動設定 Bullet

**2015-07-29：**

- 增加 meta-tag gem

**2015-07-29：**

- 使用 Libsass（SassC-rails gem）加快 sass compile 速度
- 移除 compass-rails（與 Libsass 有衝突）
- 使用 bower 的 compass-mixins 取代官方版本的 compass
- 改用相依 compass-mixins 的修改版 sassy-buttons

## Gems

### 開發工具

```ruby
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

# 可在 model 檔案中註釋 schema
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

# coding style 建議
gem "rubocop"

# 偵測 N+1 問題
gem 'bullet'

# Deploy 工具
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv', github: "capistrano/rbenv"
```

### Rails 功能

```ruby
# 使用者系統
gem "devise"

# Debug 工具
gem 'awesome_rails_console'

# flash message
gem 'growlyflash', '0.6.2'

# App settings function
gem "rails-settings-cached", "0.4.1"

# 分離敏感內容
gem 'settingslogic'

# for View components and cache
gem 'cells', "~> 4.0.0.beta2"

# 檔案上傳與影像處理
gem 'carrierwave'
gem 'mini_magick'
```

#### 可選功能

```ruby
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

if yes?("是否使用 Facebook oauth 登入 (yes/no)")
  gem "omniauth"
  gem "omniauth-facebook"
end
```

### 前端

```ruby
# 使用 compass
gem 'sprockets-rails'
gem 'sass-rails', '5.0.1'
gem 'compass-rails', '2.0.4'

# bootstrap
gem 'bootstrap-sass'

# font awesome
gem 'font-awesome-sass'

# 使用 bower 管理前端套件
gem 'bower-rails'

# modernizr
gem 'modernizr-rails'
```

`Bowerfile` 內容

```ruby
asset 'susy'
asset 'breakpoint-sass'
asset 'sassy-buttons'
asset 'modernizr'
```

#### 可選功能

```ruby
if yes?('是否使用 React.js？（yes/no）')
  gem 'react-rails', '~> 1.0'
  gem 'sprockets-coffee-react'
end
```

## assets 檔案結構

```sh
.
└── assets
    ├── images
    ├── javascripts
    │   ├── _app-base.js.coffee # 需設定 AppName
    │   ├── _plugins.js.coffee # require 需要的 libs
    │   ├── application.js.coffee
    │   └── vendor # 放第三方 snippets
    │       └── _console_err.js
    └── stylesheets
        ├── application.css.sass
        ├── pages # 依頁面整理的 sass 片段
        │   └── _index.css.sass
        └── partials
            ├── _color.css.sass # 顏色定義
            ├── _helper.css.sass # 可複用的 helpers
            ├── _layout.css.sass # 排版相關設定、placeholder
            ├── _mixins.css.sass # 自訂 mixins
            ├── _typography.css.sass # 字型相關定義
            └── _variables.css.sass # 全域變數定義
```

## views 檔案結構

```sh
.
└── views
    ├── common # 通用 partials
    │   ├── _footer.html.erb
    │   ├── _ga.html.erb
    │   └── _header.html.erb
    ├── layouts
    │   └── application.html.erb
    └── prototype
        └── index.html.erb
```

## 會自動設定的內容

自動將 `bower_components` 加入 assets pipeline。

自動設定好 Guard，開發時先在終端機輸入 `guard` 啟動即可自動重新整理瀏覽器、自動執行測試、自動重新開啟伺服器（pow）

自動建立資料庫（預設使用 sqlite）

自動產生 Prototype controller，並把 root 設定在 'prototype#index'，方便直接開始建立前端 prototype。

自動設定 SittingsLogic，設定檔為 `config/application.yml`。

自動設定 i18n（預設地區為 zh-TW），並自動新增 `zh-TW.yml` 語系檔。

自動設定 Capistrano，但仍需要依照需求編輯 `Capfile`、`config/deploy.rb`、`config/deploy/production.rb`

自動新增 shared 目錄隔離敏感資料，並自動用 `ln` hardlink 檔案到正確的位置。

自動執行 `git init`，自動做 initial commit。
