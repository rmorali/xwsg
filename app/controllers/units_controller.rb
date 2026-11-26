class UnitsController < ApplicationController
  CATEGORY_ORDER = %w[
    CapitalShip
    LightTransport
    HeavyTransport
    Interceptor
    Fighter
    Bomber
    Facility
    DefenseSystem
    Armament
    Upgrade
    Warrior
    Infantry
    Cavalry
    Artillery
    Armor
  ].freeze

  def index
    @units = Unit.all.sort_by do |u|
      [CATEGORY_ORDER.index(u.type) || 99, u.credits.to_i, u.name.to_s]
    end
  end
end