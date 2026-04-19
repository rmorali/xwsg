ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# --- CURATIVO TEMPORÁRIO PARA O RUBY 2.7 ---
require 'bigdecimal'
class BigDecimal
  def self.new(*args)
    BigDecimal(*args)
  end
end
# ------------------------------------------

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
