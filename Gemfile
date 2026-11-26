source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Core Rails 8.1
gem 'rails', '~> 8.1.0'
gem 'puma', '>= 6.4'
gem 'sqlite3', '>= 2.1'
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Autenticação & Painel Admin
gem 'devise', '>= 4.9.4'
gem 'activeadmin', '>= 3.2.2'

# Frontend & Assets (seguros e compatíveis com Rails 8 + Windows)
gem 'sprockets-rails'
gem 'sassc-rails'
gem 'terser'         # Substitui o antigo uglifier com suporte a JS moderno
gem 'turbo-rails'    # Substitui o antigo turbolinks
gem 'jquery-rails'
gem 'react-rails'
gem 'simple_form'
gem 'jbuilder'

# E-mail & Algoritmos
gem 'sendgrid-ruby'
#gem 'dijkstra', git: 'https://github.com/oscartanner/dijkstra.gem.git', ref: 'master'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw] # Substitui byebug no Ruby 3+
  gem 'rspec-rails', '>= 7.1'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers', '~> 6.0' # Removida a trava da branch rails-5
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'bundler-audit', require: false # Auditoria local de CVEs
end

group :development do
  gem 'listen'
  gem 'web-console'
end

group :test do
  gem 'selenium-webdriver'
end