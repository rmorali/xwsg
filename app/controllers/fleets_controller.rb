class FleetsController < ApplicationController
  respond_to :html, :js

  def edit
    @squad = current_squad
    @round = Round.current
    @fleet = Fleet.find(params[:id])
    @destinations = Route.in_range_for(@fleet)
    @carriables = @fleet.carriables
    @units = Unit.allowed_for(@squad.faction.name)
  end

  def move
    @fleet = Fleet.find(params[:id])
    @destination = Planet.find_by(id: fleet_params[:destination].to_i)
    @quantity = fleet_params[:quantity].to_i
    MoveFleet.new(@fleet, @quantity, @destination).order!
    redirect_back(fallback_location: root_path)
  end

  def embark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    ShipFleet.new(@quantity, @cargo, @carrier).embark!
    redirect_back(fallback_location: root_path)
  end

  def disembark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    ShipFleet.new(@quantity, @cargo, @carrier).disembark!
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
    redirect_back(fallback_location: root_path)
  end

  private

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
