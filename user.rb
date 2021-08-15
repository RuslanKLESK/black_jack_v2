class User < Player

  def choose_action
    puts '1: Пропустить'
    puts '2: Добавить карту' if hand.size != 3
    puts '3: Открыть карты'
    gets.chomp.to_i
  end
  
end
