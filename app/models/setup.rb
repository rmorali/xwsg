class Setup < ApplicationRecord
  def self.current
    Setup.last
  end
end
