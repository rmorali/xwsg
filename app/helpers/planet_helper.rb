module PlanetHelper
  def planet_aura_data(planet, squad, visible_fleets, radar_fleets, fog_fleets)
    under_attack = planet.under_attack?
    classes = []
    classes << 'is-contested' if under_attack

    # 1. Verifica se o próprio esquadrão está presente no planeta
    own_fleet = visible_fleets.find { |f| f.squad == squad } ||
                planet.fleets.find { |f| f.squad == squad }

    aura_color = if own_fleet
                   squad.color.presence || '#38bdf8'
                 elsif radar_fleets.any?
                   # 2a. Esquadrão inimigo detectado por radar
                   radar_fleets.first.squad&.color.presence || '#ef4444'
                 elsif fog_fleets.any?
                   # 2b. Esquadrão inimigo registrado no Fog of War
                   fog_fleets.first.squad&.color.presence || '#ef4444'
                 end

    if aura_color.present?
      classes << 'has-aura'
    end

    style = aura_color.present? ? "--planet-aura-color: #{aura_color};" : ''

    {
      classes: classes.join(' '),
      style: style,
      under_attack: under_attack
    }
  end
end