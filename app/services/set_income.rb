class SetIncome
  def initialize(planet, squad)
    @squad = squad
    @planet = planet
  end

  def current
    income = 0
    presence_for_domination = 20000
    total_presence = 0
    @planet.fleets_presence.each do |f|
      total_presence += f[1]
    end
    ratio = ( total_presence.to_f / presence_for_domination.to_f )
    @planet.fleets_presence.each do |f|
      squad = f[0]
      squad_presence = f[1]
      if squad.id == @squad.id
        squad_ratio = squad_presence.to_f / presence_for_domination.to_f
        income = @planet.credits.to_f * squad_ratio.to_f * ratio.to_f
      end
    end
    income.to_i
  end
end