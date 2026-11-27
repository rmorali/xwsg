class SquadsController < ApplicationController
  respond_to :html, :js
  def index; end

  def new
    @squad = Squad.new
    @factions = Faction.all
    @colors = %w[Vermelho Amarelo Verde Roxo Cyano Random]
  end

  def create
    @squad = Squad.create(squad_params)
    @squad.update(color: resolve_color(squad_params[:color]), credits: 1000)
    current_user.squad = @squad
    current_user.save
    redirect_to squads_map_path
  end

  def edit
    @squad = current_squad
    @colors = build_color_options(@squad.color)
  end

  def update
    @squad = current_squad
    color = squad_params[:color].blank? ? @squad.color : resolve_color(squad_params[:color])
    @squad.update(squad_params.merge(color: color))
    redirect_back(fallback_location: root_path)
  end

  def ready
    current_squad.ready!
    redirect_to squads_map_path
  end

  def map
    @squad = current_squad
    @squad_credits = @squad.credits
    @squad_income = SetIncome.new(@squad, Planet.first).total
    @map_ratio = @squad.map_ratio.to_f / 100.to_f
    @map_x_adjust = 10
    @map_y_adjust = 70
    @planets = Planet.all
    @round = Round.current
    @setup = Setup.current
    @status = ""
    @squads = Squad.all
    @squads.each do |squad|
      @status << "<span style=color:#{squad.color}>" + squad.name + " pronto!</span><br>" if squad.ready?
      @status << "<span style=color:#{squad.color}>" + squad.name + " eliminado!</span><br>" if Fleet.none? { |f| f.squad == squad && (f.type == 'CapitalShip' || f.type == 'Facility') }
    end
  end

  private

  def resolve_color(selected)
    return "##{([*('A'..'F'), *('7'..'9')] - %w[0 1 I O]).sample(6).join}" if selected == 'Random'

    Squad::TACTICAL_COLORS[selected] || selected
  end

  def build_color_options(current_hex)
    options = Squad::TACTICAL_COLORS.map { |name, hex| [name, hex] }
    if current_hex.present? && !Squad::TACTICAL_COLORS.value?(current_hex.upcase)
      options.unshift(["Atual (#{current_hex})", current_hex])
    end
    options << ['Random', 'Random']
  end

  def squad_params
    params.require(:squad).permit(:name, :color, :faction_id, :url, :map_ratio, :ai, :ai_level)
  end
end