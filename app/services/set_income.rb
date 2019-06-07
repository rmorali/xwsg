class SetIncome
  def initialize(squad, planet)
    @squad = squad
    @planet = planet
    @setup = Setup.current
  end

  def current
    income = 0
    presence_for_domination = @setup.minimum_fleet_for_dominate
    total_presence = 0
    @planet.fleets_presence.each do |f|
      total_presence += f[1]
    end
    ratio = ( total_presence.to_f / presence_for_domination.to_f )
    @planet.fleets_presence.each do |f|
      squad = f[0]
      squad_presence = f[1]
      squad_presence = presence_for_domination if squad_presence > presence_for_domination
      if squad.id == @squad.id
        squad_ratio = squad_presence.to_f / presence_for_domination.to_f
        income = @planet.credits.to_f * squad_ratio.to_f * ratio.to_f
      end
    end
    income.to_i
  end

  def total
    income = 0
    Planet.seen_by(@squad).each do |p|
      income += SetIncome.new(@squad, p).current
    end
    income
  end
end
