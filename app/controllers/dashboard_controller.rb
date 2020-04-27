class DashboardController < ApplicationController

  def index

  end

  def show
    @squads = Squad.all
    @squad = current_squad
    @squad_income = SetIncome.new(@squad, Planet.first).total
    @planets = Planet.all
    @round = Round.current
    @setup = Setup.current
  end

end
