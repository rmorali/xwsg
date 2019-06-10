class ResultsController < ApplicationController

  def index
    @squad = current_squad
    @enemies = Squad.all.reject { |s| s == current_squad}
    @round = Round.current
    @rounds = Round.results_for(@squad)
  end

  def create
    @results = result_params
    saved_results = @results.each do |id, attributes|
      result = Result.find(id.to_i)
      result.update(attributes)
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def result_params
    params.require("results").permit!
  end

end