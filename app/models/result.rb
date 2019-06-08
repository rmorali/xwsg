class Result < ApplicationRecord
  belongs_to :round
  belongs_to :unit
  belongs_to :fleet
  belongs_to :squad
  belongs_to :planet
  belongs_to :captor, class_name: 'Squad', foreign_key: 'captor_id', optional: true
  belongs_to :carrier, class_name: 'Result', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true

  delegate :name, :credits, :type, :influence_ratio, :facility?, :image, :hyperdrive, :groupable, :carriable, to: :unit

  def cargo
    Result.where(carrier: self)
  end
end
