class SquadsController < ApplicationController
  respond_to :html, :js
  def index; end

  def new
    @squad = Squad.new
    @factions = Faction.all
    @colors = %w[Red Green Yellow White Purple]
  end

  def create
    @squad = Squad.create(squad_params)
    current_user.squad = @squad
    current_user.save
    redirect_to(root_path)
  end

  def edit; end

  def update
    current_user.squad.ready!
    redirect_to squads_map_path
  end

  def map
    @map_ratio = 1
    @map_x_adjust = 0
    @map_y_adjust = 65
    @squad = current_user.squad
    @planets = Planet.all
    @round = Round.current
  end

  private

  def squad_params
    params.require(:squad).permit(:name, :color, :faction_id, :url)
  end
end
