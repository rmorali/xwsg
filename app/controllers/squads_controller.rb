class SquadsController < ApplicationController

  def index
  end

  def new
    @squad = Squad.new
    @factions = Faction.all
    @colors = %w[Red Green Yellow White Purple]
  end
end
