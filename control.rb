class Control

  attr_reader :current_player

  def initialize
    @user           = User.new
    @dealer         = Dealer.new
    @deck           = nil
    @bank           = 0
    @current_player = nil
    @finish_round   = nil
  end

  def start
    greetings
    new_round!

    loop do
      make_turn
    end
  end

  private

  def make_turn
    action = current_player.choose_action

    case action
      when 1 then skip_turn
      when 2 then take_card(current_player)
      when 3 then @finish_round = true
    else puts 'Не корректный ввод.'
    end

    choose_winner if @finish_round || check_three_cards!
  end

  def new_round!
    @deck         = Deck.new
    @finish_round = false
    @user.refresh!
    @dealer.refresh!

    puts 'Игра началась!', 'Вы получаете 2 карты:'
    give_two_cards(@user)
    @user.show_cards

    puts 'Дилер получает 2 карты:'
    give_two_cards(@dealer)
    puts '**'

    make_bets(10)

    @current_player = @user
  end

  def ask_for_more
    puts 'Продолжить игру? <Y>'
    action = gets.chomp.upcase

    if action == 'Y'
      new_round!
    else
      puts 'Всего хорошего, и спасибо за игру!'
      exit!
    end
  end

  def choose_winner
    show_both_hands

    if (@user.points > 21 && @dealer.points > 21) || @user.points == @dealer.points
      user_draw
    elsif @user.points > 21
      user_lost
    elsif @dealer.points > 21 || @user.points > @dealer.points
      user_win
    else
      user_lost
    end

    @bank = 0
    ask_for_more
  end

  def user_win
    puts 'Вы победили!'
    @user.give_money(@bank)
  end

  def user_lost
    puts 'Вы проиграли!'
    @dealer.give_money(@bank)
  end

  def user_draw
    puts "Ничья!"
    @user.give_money(@bank / 2)
    @dealer.give_money(@bank / 2)
  end

  def check_three_cards!
    @finish_round = (@user.hand.size == 3 && @dealer.hand.size == 3)
  end

  def greetings
    puts "Введите ваше имя:"
    @user.name = gets.chomp
  end

  def take_card(player)
    player.draw_card(@deck)

    if player.is_a?(User)
      @user.show_cards
    end

    skip_turn
  end

  def give_two_cards(player)
    2.times { player.draw_card(@deck) }
  end

  def make_bets(amount)
    @user.take_money(amount)
    @dealer.take_money(amount)

    @bank += (amount * 2)
  end

  def skip_turn
    change_player
    puts "Теперь ход #{@current_player.class}."
  end

  def show_both_hands
    puts 'Игрок:'
    @user.show_cards

    puts 'Дилер:'
    @dealer.show_cards
  end

  def change_player
    @current_player = (@current_player == @user ? @dealer : @user)
  end
  
end
