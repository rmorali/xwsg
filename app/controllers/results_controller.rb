class ResultsController < ApplicationController

  def index
    @squad = current_squad
    @enemies = Squad.all.reject { |s| s == current_squad}
    @round = Round.current
    @rounds = Round.results_for(@squad)
  end

  def create
  	raise result_params.inspect
    redirect_back(fallback_location: root_path)
  end

  private

  def result_params
    params.require("results").permit!
  end

end