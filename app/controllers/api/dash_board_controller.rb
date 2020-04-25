class Api::DashBoardController < ApplicationController

  def index
    @squads = Squad.all
    @squad = current_squad
    @squad_income = SetIncome.new(@squad, Planet.first).total
    @planets = Planet.all
    @round = Round.current
    @setup = Setup.current
    respond_to do |format|
      format.json { render :json => @squads }
    end
  end

  def show
    @squads = Squad.all
    @squad = current_squad
    @squad_income = SetIncome.new(@squad, Planet.first).total
    @planets = Planet.all
    @round = Round.current
    @setup = Setup.current
    respond_to do |format|
      format.json { render :json => @squads }
    end
  end

end
