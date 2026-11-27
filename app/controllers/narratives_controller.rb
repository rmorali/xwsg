class NarrativesController < ApplicationController
  def index
    @current_round = Round.current
    # Ordena do turno mais recente (topo) para os turnos passados (abaixo)
    @rounds = Round.where.not(narrative: [nil, '']).order(id: :desc)
  end
end