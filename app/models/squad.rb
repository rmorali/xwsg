class Squad < ApplicationRecord
  has_many :fleets
  belongs_to :faction
  has_many :users

  def debit_credits(value)
    update(credits: credits - value) if value <= credits
  end

  def debit_metals(value)
    update(metals: metals - value) if value <= metals
  end

  def debit_resources(credit, metal)
    return if credit > credits || metal > metals
    debit_credits(credit)
    debit_metals(metal)
  end

  def ready!
    state = case ready
            when true then false
            when !true then true
    end
    update(ready: state)
    GameLogic.new.check_state!
  end
end
