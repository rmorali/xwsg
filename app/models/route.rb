class Route < ApplicationRecord

  belongs_to :vector_a, class_name: 'Planet', foreign_key: 'vector_a'
  belongs_to :vector_b, class_name: 'Planet', foreign_key: 'vector_b'
  
  def self.getEdges
    edges = []
    Route.all.each do |r|
      edges << [r.vector_a, r.vector_b, r.distance]
      edges << [r.vector_b, r.vector_a, r.distance]
    end
    edges
  end
  
end
