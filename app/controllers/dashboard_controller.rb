class DashboardController < ApplicationController

  def index

  end

  def show
    @squads = Squad.all
    @planets = Planet.all
  end

end
