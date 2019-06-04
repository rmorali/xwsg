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

  def fog_for(squad)
    results.where.not(squad: squad)
    # TODO: Show fog of planet based on results table
  end
  # TODO: Verify if a squad can build facilities, produce units etc
end
