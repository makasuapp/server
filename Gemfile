source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.0.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'figaro'

gem 'devise'
gem 'activeadmin'
gem 'cancan'

gem 'jwt'

#sentry for error reporting
gem "sentry-raven"
#skylight.io for apm
gem "skylight"

gem 'sorbet', :group => :development
gem 'sorbet-runtime'
gem 'sorbet-rails'

gem 'dalli'
gem 'pundit'

gem "activerecord-import"

gem 'aasm'
gem 'paper_trail'

gem 'fcm'

gem 'http'
gem 'roar'
gem 'multi_json'

gem 'lograge'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'mocha'
end

group :development do
  gem 'bullet'

  gem "letter_opener"
  gem 'annotate'

  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.14.0'
  gem 'capistrano3-puma', '~> 4.0.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-figaro-yml', '~> 1.0.2'
  gem 'capistrano-rails-console', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
