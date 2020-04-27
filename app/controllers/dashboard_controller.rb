class DashboardController < ApplicationController
  before_action :load_objects, except: [:teste]
  def index
    
  end

  def show

  end

  def teste
  end

  private
    def load_objects
      @squads = Squad.all
      @planets = Planet.all
    end
end
