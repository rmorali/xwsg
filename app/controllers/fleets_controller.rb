class FleetsController < ApplicationController

  def edit
    @fleet = Fleet.find(params[:id])
    @destinations = Route.in_range_for(@fleet)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @fleet = Fleet.find(params[:id])
    @destination = Planet.find_by(id: fleet_params[:destination].to_i)
    @quantity = fleet_params[:quantity].to_i
    OrderMovement.new(@fleet, @quantity, @destination)
    redirect_to squads_map_path
  end

  private

  def fleet_params
    params.require(:fleet).permit(:destination, :quantity)
  end

end
