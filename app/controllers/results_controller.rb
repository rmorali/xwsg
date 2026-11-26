class ResultsController < ApplicationController
  def index
    @squad = current_squad
    @enemies = Squad.all
    @round = Round.current
    @rounds = Round.results_for(@squad)
    @my_reports = BattleReport.where(squad: @squad, round: @rounds).index_by(&:round_id)
  end

  def create
    @results = result_params
    @results.each do |id, attributes|
      result = Result.find(id.to_i)
      result.update(attributes)
    end
    redirect_back(fallback_location: root_path)
  end

  def save_report
    report = BattleReport.find_or_initialize_by(
      round_id: report_params[:round_id],
      squad: current_squad
    )
    report.content = report_params[:content].to_s.strip
    report.save!

    redirect_back(fallback_location: results_path)
  end

  private

  def result_params
    params.require('results').permit!
  end

  def report_params
    params.require(:battle_report).permit(:round_id, :content)
  end
end