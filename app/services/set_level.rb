class SetLevel
  def initialize(fleet)
    @fleet = fleet
  end
  def upgrade
    @fleet.update(level: @fleet.level += 1)
  end
  def upgrade!
    @fleet.update(level: @fleet.level += 3)
  end

end
