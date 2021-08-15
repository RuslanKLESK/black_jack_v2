class Hand

  def initialize
    @cards = []
  end

  def add(card)
    @cards << card
  end

  def show
    @cards.each { |card| puts "Карты: #{card.value}#{card.suit}" }
  end

  def size
    @cards.size
  end
  
end
