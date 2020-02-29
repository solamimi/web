source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# コンソールをまともにする
gem 'pry-rails'
gem 'pry-doc'

# platform windows only?
gem 'rb-readline', require: false

# ログフォーマッター
gem 'log4r'

## DB
# created_by, updated_by, deleted_byを自動挿入
gem 'record_with_operator'
# セッションをDBに格納
gem 'activerecord-session_store'
# 現在のDBをseedに吐き出す
gem 'seed_dump'

## helper
# viewのフォームをシンプルに
gem 'simple_form'
# ページネート
gem 'kaminari'
# enumのヘルパーを提供
gem 'enum_help'

## assets
# JSライブラリ達
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "select2-rails"
gem 'momentjs-rails'
gem 'bootstrap-datepicker-rails'
# bootstrap
gem 'bootstrap', '~> 4.3.1'
gem 'material-sass', '4.1.1'
gem 'material_icons'

group :development, :test do
  # コンソールでActiveRecordオブジェクトを整形
  # gem 'hirb'
  # gem 'hirb-unicode'
  # エラー画面をわかりやすく
  gem 'better_errors'
  # エラー場面でデバッグ
  gem 'binding_of_caller', platform: :ruby
  # i18nを自動生成
  gem 'i18n_generators'
  # schemeをWebで確認
  gem 'ryakuzu'
  # N+1を検知
  gem 'bullet'
  # schemeをmodelに書き出す
  gem 'annotate'
  # gemのライセンスをチェック
  gem 'license_finder'
  # コーディング規約
  gem 'rubocop'
  # セキュリティチェック
  gem 'brakeman'
  # gemの脆弱性チェック
  gem 'bundler-audit'
  # フォーマッター
  gem 'rufo'
  # ER図自動生成
  gem 'rails-erd'
end

gem 'google-api-client'
gem 'google_drive'

gem 'dotenv-rails'
