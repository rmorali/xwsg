class Result < ApplicationRecord
  default_scope { order(squad_id: :ASC, updated_at: :ASC) }
  belongs_to :round
  belongs_to :unit
  belongs_to :fleet
  belongs_to :squad
  belongs_to :planet
  belongs_to :captor, class_name: 'Squad', foreign_key: 'captor_id', optional: true
  belongs_to :carrier, class_name: 'Result', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true

  delegate :name, :credits, :type, :influence_ratio, :facility?, :image,
           :hyperdrive, :groupable, :carriable, :producing_time, to: :unit

  validates_numericality_of :blasted, :fled, :captured, allow_nil: true
  validate :captor_if_captured
  validate :posted_results

  def moving?
    true if destination
  end

  def in_production?
    ready_in.to_i > 0
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
