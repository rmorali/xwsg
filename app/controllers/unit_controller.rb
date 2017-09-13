class UnitController < ApplicationController
  def index
    @units = Unit.all
  end
end
