source 'https://rubygems.org' # ATUALIZADO: Segurança (https)

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'devise'
gem 'dijkstra', git: 'https://github.com/oscartanner/dijkstra.gem.git'
gem 'erubis'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
gem 'jquery-rails'

# Use Puma as the app server
gem 'puma', '>= 5.0'

gem 'bootsnap' # ATUALIZADO: Adicionado para melhorar o tempo de boot (veja config/boot.rb)

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.0' # ATUALIZADO: Próxima versão menor (minor version)

gem 'react-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Simple Form Rails
gem 'simple_form'

# SQLite3 para Rails 8 exige versão 2.1 ou superior
gem 'sqlite3', '>= 2.1'

# ATUALIZADO: therubyracer está obsoleto. mini_racer é o substituto moderno.
gem 'mini_racer', platforms: :ruby 

# Turbolinks makes navigating your web application faster.
gem 'turbolinks'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier'

gem 'activeadmin'

# gem 'thin' # COMENTADO: Use o Puma (acima). Ter dois servidores pode causar confusão.
gem 'sendgrid-ruby'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  
  # ATUALIZADO: factory_girl mudou de nome para factory_bot
  gem 'factory_bot_rails' 
  
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
end

group :development do
  gem 'listen'
  #gem 'spring'
  #gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end