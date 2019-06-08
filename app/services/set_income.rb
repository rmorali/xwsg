class SetIncome
  def initialize(squad, planet)
    @squad = squad
    @planet = planet
    @setup = Setup.current
  end

  def current
    return unless @planet.fleets.any? { |f| f.squad == @squad }
    influence_for_domination = @setup.minimum_fleet_for_dominate
    total_influence = 0
    squad_influence = 0
    enemies_influence = 0
    @planet.fleets_influence.each do |f|
      total_influence += f[1]
      squad_influence += f[1] if f[0] == @squad
      enemies_influence += f[1] if f[0] != @squad
    end  
    squad_influence = influence_for_domination if squad_influence > influence_for_domination
    enemies_influence = influence_for_domination if enemies_influence > influence_for_domination
    squad_ratio = squad_influence.to_f / influence_for_domination
    income = 0
    income = squad_ratio.to_f * @planet.income 
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
