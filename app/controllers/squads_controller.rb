class SquadsController < ApplicationController
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

  def updated; end

  private

  def squad_params
    params.require(:squad).permit(:name, :color, :faction_id, :url)
  end
end
