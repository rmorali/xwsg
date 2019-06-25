class GameLogic
  def initialize
    @squads = Squad.all
    @round = Round.current
    @setup = Setup.current
  end

  def new_game!
    Planet.update_all(credits: 100)
    SetWormhole.new.create!
    Squad.all.each do |squad|
      set_initial(squad)
      warp_fleets_for(squad)
      AiFleet.new(squad).act!
    end
    Planet.all.each do |planet|
      GroupFleet.new(planet).group!
    end

  end

  def check_state!
    if @squads.all?(&:ready?) == true
      @round.next_phase!
      @squads.update_all(ready: nil)
      check_phase!
    end
    send_mail(@round)
  end

  def check_phase!
    strategy! if @round.strategy?
    space_combat! if @round.space_combat?
    finished! if @round.finished?
  end

  def strategy!; end

  def space_combat!
    UpdateFleet.new.move!
    CreateResult.new.create!
    ai_squads = Squad.where(ai: true)
    ai_squads.each do |squad|
      squad.update(ready: true)
    end
  end

  def ground_combat!; end

  def finished!;
    results = Result.where(round: @round)
    results.each do |result|
      ApplyResult.new(result).apply!
    end
    Squad.all.each do |squad|
      squad.credits += SetIncome.new(squad, Planet.first).total
      squad.save
    end
    UpdateFleet.new.build!
    ai_squads = Squad.where(ai: true)
    ai_squads.each do |squad|
      AiFleet.new(squad).act!
    end
    Fleet.where('ready_in < ?', 0).update_all(ready_in: 0)
  end

  def warp_fleets_for(squad)
    planets_quantity = @setup.initial_planets
    available = squad.credits / planets_quantity
    planets_quantity.times do
      for_facilities = available * 0.30
      for_capital_ships = available * 0.40
      for_fighters = available * 0.30
      planet = Planet.random
      until for_facilities < 1200 do
        facilities = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Facility', for_facilities)
        facility = facilities[rand(facilities.count)] unless facilities.empty?
        BuildFleet.new(1, facility, squad, planet).build! unless facility.nil?
        for_facilities -= facility.credits
      end
      until for_capital_ships < 300 do
        capital_ships = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'CapitalShip', for_capital_ships)
        capital_ship = capital_ships[rand(capital_ships.count)] unless capital_ships.empty?
        BuildFleet.new(1, capital_ship, squad, planet).build! unless capital_ship.nil?
        for_capital_ships -= capital_ship.credits
      end
      for_fighters = for_fighters / 2
      2.times do
        fighters = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Fighter', for_fighters)
        fighter = fighters[rand(fighters.count)]
        BuildFleet.new( (for_fighters / fighter.credits).to_i, fighter, squad, planet).build!
      end
      GroupFleet.new(planet).group!
    end
  end

  def set_initial(squad)
    squad.update(credits: @setup.initial_credits)
  end

  def send_mail(phase)
    from = Email.new(email: 'rodrigo.morali@gmail.com')
    to = Email.new(email: 'rodrigo.morali@gmail.com')
    subject = 'XWSG News'
    content = Content.new(type: 'text/plain', value: 'Alguem passou o turno')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

end

# using SendGrid's Ruby Library
# https://github.com/sendgrid/sendgrid-ruby
