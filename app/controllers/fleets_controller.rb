class FleetsController < ApplicationController
  respond_to :html, :js

  def edit
    @setup = Setup.current
    @squad = current_squad
    @round = Round.current
    @fleet = Fleet.find(params[:id])
    @planet = @fleet.planet
    @destinations = Route.in_range_for(@fleet)
    @carriables = @fleet.carriables
    @units = Unit.allowed_for(@squad.faction.name)
    @units = @units.where.not(type: 'Armament')
    @units = @units.where.not(type: 'Facility') if @fleet.type == 'Facility'
    @units = @units.where(type: 'Facility') if @fleet.type == @setup.builder_unit
    @armables = @planet.fleets.select { |fleet| fleet.armable? && fleet.squad == @squad }
    @armaments = Unit.allowed_for(@squad.faction.name).where(type: 'Armament')
  end

  def move
    @fleet = Fleet.find(params[:id])
    @destination = Planet.find_by(id: fleet_params[:destination].to_i)
    @quantity = fleet_params[:quantity].to_i
    MoveFleet.new(@fleet, @quantity, @destination).order!
    GroupFleet.new(@fleet.planet).group!
    redirect_back(fallback_location: root_path)
  end

  def embark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    ShipFleet.new(@quantity, @cargo, @carrier).embark!
    GroupFleet.new(@carrier.planet).group!
    redirect_back(fallback_location: root_path)
  end

  def disembark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    ShipFleet.new(@quantity, @cargo, @carrier).disembark!
    GroupFleet.new(@carrier.planet).group!
    redirect_back(fallback_location: root_path)
  end

  def build
    @squad = current_squad
    @carrier = Fleet.find(params[:id])
    @facility = nil
    @facility = @carrier if @carrier.type == 'Facility'
    @unit = Unit.find(build_params[:unit])
    @quantity = build_params[:quantity].to_i
    BuildFleet.new(@quantity, @unit, @squad, @carrier.planet, @facility).build!
    GroupFleet.new(@carrier.planet).group!
    redirect_back(fallback_location: root_path)
  end

  def arm
    @fleet = Fleet.find(arm_params[:id])
    @quantity = arm_params[:quantity].to_i
    @armament = Unit.find(arm_params[:armament])
    ArmFleet.new(@fleet, @quantity, @armament).arm!
    GroupFleet.new(@fleet.planet).group!
    redirect_back(fallback_location: root_path)
  end

  def upgrade
    @fleet = Fleet.find(upgrade_params[:id])
    SetLevel.new(@fleet).upgrade!
    redirect_back(fallback_location: root_path)
  end

  private

  def arm_params
    params.require(:custom).permit!
  end

  def upgrade_params
    params.require(:custom).permit!
  end

  def fleet_params
    params.require(:fleet).permit(:destination, :quantity)
  end

  def cargo_params
    params.require(:custom).permit(:id, :quantity)
  end

  def build_params
    params.require(:fleet).permit(:id, :quantity, :unit)
  end
end
