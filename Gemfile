source 'https://rubygems.org' # ATUALIZADO: Segurança (https)

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'devise'
gem 'dijkstra', git: 'https://github.com/oscartanner/dijkstra.gem.git'
gem 'erubis'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7' # ATUALIZADO: Versão mais adequada para Rails 5.2
gem 'jquery-rails'

# Use Puma as the app server
gem 'puma', '~> 3.11' # ATUALIZADO: Melhor estabilidade para 5.2

gem 'bootsnap' # ATUALIZADO: Adicionado para melhorar o tempo de boot (veja config/boot.rb)

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.8' # ATUALIZADO: Próxima versão menor (minor version)

gem 'react-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Simple Form Rails
gem 'simple_form'

# SQLite3 para Rails 5.2 geralmente exige versão < 1.4 se você usar Ruby mais antigo
gem 'sqlite3', '~> 1.3.6' # ATUALIZADO: Fixado para evitar incompatibilidade inicial

# ATUALIZADO: therubyracer está obsoleto. mini_racer é o substituto moderno.
gem 'mini_racer', platforms: :ruby 

# Turbolinks makes navigating your web application faster.
gem 'turbolinks', '~> 5'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'

gem 'activeadmin'

# gem 'thin' # COMENTADO: Use o Puma (acima). Ter dois servidores pode causar confusão.
gem 'sendgrid-ruby'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  
  # ATUALIZADO: factory_girl mudou de nome para factory_bot
  gem 'factory_bot_rails' 
  
  gem 'faker', '1.8.4'
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
end

group :development do
  gem 'listen'
  #gem 'spring'
  #gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end