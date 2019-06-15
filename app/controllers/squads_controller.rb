class SquadsController < ApplicationController
  respond_to :html, :js
  def index; end

  def new
    @squad = Squad.new
    @factions = Faction.all
    @colors = %w[Vermelho Amarelo Verde Roxo Cyano]
  end

  def create
    @squad = Squad.create(squad_params)
    color = case squad_params[:color]
      when 'Vermelho' then '#FF0000'
      when 'Amarelo' then '#FFFF00'
      when 'Verde' then '#00FF00'
      when 'Roxo' then '#AA55FF'
      when 'Cyano' then '#00FFFF'
    end
    @squad.update(color: color, credits: 1000)
    current_user.squad = @squad
    current_user.save
    redirect_to squads_map_path
  end

  def edit; end

  def update
    current_squad.ready!
    redirect_to squads_map_path
  end

  def map
    @map_ratio = 1
    @map_x_adjust = 80
    @map_y_adjust = 20
    @squad = current_squad
    @squad_credits = @squad.credits
    @squad_income = SetIncome.new(@squad, Planet.first).total
    @planets = Planet.all
    @round = Round.current
    @setup = Setup.current
    @status = ""
    @squads = Squad.all
    @squads.each do |squad|
      @status << "<span style=color:#{squad.color}>" + squad.name + " pronto!</span><br>" if squad.ready?
    end
  end

  private

  def squad_params
    params.require(:squad).permit(:name, :color, :faction_id, :url)
  end
end
