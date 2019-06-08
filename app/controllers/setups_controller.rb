class SetupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @setup = Setup.current
    @units = ['Facility','CapitalShip','LightTransport','HeavyTransport']
    @round = Round.current
  end

  def edit
    @setup = Setup.current
  end

  def update
    @setup = Setup.find(params[:id])
    @setup.update(setup_params)
    redirect_back(fallback_location: root_path)
  end

  def new_game
    @round = Round.current
    GameLogic.new.new_game!
  end

  def finaliza_turno
    squads = Squad.all
    squads.each { |s| s.ready! }
    @round = Round.current
  end

  private

  def setup_params
    params.require(:setup).permit(
      :planet_income_ratio,
      :initial_credits,
      :initial_planets,
      :initial_wormholes,
      :minimum_fleet_for_dominate,
      :minimum_fleet_for_build,
      :builder_unit,
      :ai,
      :ai_level)
  end
end
