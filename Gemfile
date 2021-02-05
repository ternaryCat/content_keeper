source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
# gem 'redis', '~> 4.0'
# gem 'bcrypt', '~> 3.1.7'
gem 'dotenv-rails'
gem 'strong_migrations'
gem 'telegram-bot'
gem 'dry-initializer'

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'pry-rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rails_best_practices'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'bullet'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
