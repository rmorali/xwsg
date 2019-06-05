class Planet < ApplicationRecord
  scope :seen_by, ->(squad) { joins(:fleets).where(fleets: {squad: squad}).group("planets.id") }
  scope :result_seen_by, ->(squad) { joins(:results).where(results: {squad: squad}).group("planets.id") }

  serialize :domination, Hash
  has_many :fleets
  has_many :results

  def image
    "planets/#{name.downcase}.png"
  end

  def under_attack?
    return true if fleets.distinct.count('squad_id') > 1
  end

  def fog_seen_by(squad)
    # TODO: Show fog of planet based on results table
    fog = []
    results.sort_by { |a| [a.round.number, a.squad.name, a.unit.id, a.quantity] }.each do |combat|
      fog << combat if combat.round.number >= results.maximum("round_id") && combat.squad != squad 
    end
    fog
  end
  # TODO: Verify if a squad can build facilities, produce units etc
end