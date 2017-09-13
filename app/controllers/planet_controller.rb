class PlanetController < ApplicationController
  def index
    @planets = Planet.all
  end
end
