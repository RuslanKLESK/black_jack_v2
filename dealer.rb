class Dealer < Player

  def choose_action
    points < 17 ? 2 : 1
  end
  
end
