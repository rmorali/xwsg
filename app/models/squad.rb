class Squad < ApplicationRecord
  TACTICAL_COLORS = {
    'Vermelho' => '#FF0000',
    'Amarelo'  => '#FFFF00',
    'Verde'    => '#00FF00',
    'Roxo'     => '#AA55FF',
    'Cyano'    => '#00FFFF'
  }.freeze

  has_many :fleets
  belongs_to :faction
  has_many :users
  has_many :messages
  has_many :battle_reports, dependent: :destroy

  def debit_credits(value)
    update(credits: credits - value) if value <= credits
  end

  def debit_resources(value)
    return false if value > credits
    debit_credits(value)
  end

  def ready!
    state = case ready?
            when true then false
            when !true then true
            end
    update(ready: state)
    GameLogic.new.check_state!
  end

  def image
    "squads/#{faction.name.downcase}.png"
  end
end