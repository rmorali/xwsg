class SetLevel
  def initialize(fleet)
    @fleet = fleet
    @setup = Setup.current
    @squad = @fleet.squad
  end
  def upgrade
    @fleet.update(level: @fleet.level += 1)
  end
  def upgrade!
    @fleet.update(level: @fleet.level += 3) if valid?
  end
  def valid?
    upgrade_cost = @setup.upgrade_cost
    @squad.debit_resources(upgrade_cost)
  end
end
