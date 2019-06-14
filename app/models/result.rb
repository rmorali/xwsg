class Result < ApplicationRecord
  default_scope { order(squad_id: :ASC, unit_id: :ASC) }
  belongs_to :round
  belongs_to :unit
  belongs_to :fleet
  belongs_to :squad
  belongs_to :planet
  belongs_to :captor, class_name: 'Squad', foreign_key: 'captor_id', optional: true
  belongs_to :carrier, class_name: 'Result', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true
  belongs_to :armament, class_name: 'Unit', foreign_key: 'armament_id', optional: true

  delegate :name, :credits, :type, :influence_ratio, :facility?, :image,
           :hyperdrive, :groupable, :carriable, :armable, :armory, :producing_time, to: :unit

  validates_numericality_of :blasted, :fled, :captured, allow_nil: true
  validate :captor_if_captured
  validate :posted_results

  def armory?
    armory
  end

  def movable?
    true unless hyperdrive.to_i < 1 || in_production? || Route.in_range_for(fleet).empty?
  end

  def moving?
    true if destination
  end

  def in_production?
    ready_in.to_i > 0
  end

  def production_status
    100.to_f / (ready_in + 1).to_f
  end

  def builder?
    @setup = Setup.current
    ability = nil
    ability = true if type == 'Facility'
    ability = true if type == @setup.builder_unit && quantity >= @setup.minimum_fleet_for_build
    ability = false if moving? || in_production?
    ability
  end

  def radar?
    level >= 3 && type == 'CapitalShip'
  end

  def cargo
    Result.where(carrier: self)
  end

  def capacity
    quantity * unit.capacity
  end

  def available_capacity
    loaded = 0
    cargo.each { |cargo| loaded += cargo.weight }
    capacity - loaded
  end

  def used_capacity
    capacity - available_capacity
  end

  def weight
    quantity * unit.weight
  end

  def captor_if_captured
    return errors.add :captor, :empty if captured.to_i > 0 && !captor
    true
  end

  def posted_results
    posted = blasted.to_i + fled.to_i + captured.to_i
    return errors.add :blasted, 'exceed fleet quantity' if posted > quantity.to_i || posted < 0
    true
  end

end
