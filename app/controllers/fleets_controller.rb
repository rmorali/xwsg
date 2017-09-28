class FleetsController < ApplicationController
  respond_to :html, :js
  def edit
    @fleet = Fleet.find(params[:id])
    @destinations = Route.in_range_for(@fleet)
    @carriables = @fleet.carriables
  end

  def move
    @fleet = Fleet.find(params[:id])
    @destination = Planet.find_by(id: fleet_params[:destination].to_i)
    @quantity = fleet_params[:quantity].to_i
    OrderMovement.new(@fleet, @quantity, @destination).move!
    redirect_to squads_map_path
  end

  def embark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    Shipment.new(@quantity, @cargo, @carrier).embark!
    redirect_to squads_map_path
  end

  def disembark
    @carrier = Fleet.find(params[:id])
    @cargo = Fleet.find(cargo_params[:id])
    @quantity = cargo_params[:quantity].to_i
    Shipment.new(@quantity, @cargo, @carrier).disembark!
    redirect_to squads_map_path
  end

  private

  def fleet_params
    params.require(:fleet).permit(:destination, :quantity)
  end

  def cargo_params
    params.require(:custom).permit(:id, :quantity)
  end
end
