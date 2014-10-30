class Player
  
  attr_accessor :hand, :pot, :folded, :name

  def initialize(name, hand)
    @name = name
    @hand = hand
    @pot = 500
    @folded = false
  end
  
  def player_turn(game)
    p "Your hand:"
    p @hand.to_s
    answer = 0
    loop do
      p "Would you like to raise a bet(1), or fold your cards(2)?"
      answer = gets.chomp.to_i
      [1, 2].include?(answer) ? break : (p "Please enter a 1 or 2.")
    end
    case answer
    when 1
      if @pot < game.current_bet
        p "You don't have enough money to match the current bet, so you fold instead."
        fold_cards
      else
        raise_bet(game)
      end
    when 2
      fold_cards
    end
    
    unless @folded || game.deck.empty?
      p "Would you like to discard any cards? (y/n)"
      gets.chomp == "y" ? discard_cards(game) : return
    end
  end

  def receive_winnings(game_pot)
    @pot += game_pot
  end
   
  
  #can discard up to the 5 cards in your hand per turn after the bet, cannot discard if folded
  def discard_cards(game)
    deck = game.deck
    cards = []
    p "There are only #{deck.count} cards left in the deck, you can discard only up to this amount." if deck.count < 5
    loop do
      p "Enter the card numbers you would like to discard (1, 2, 5):"
      cards = gets.chomp.scan(/\d/).map!(&:to_i)
      (cards.all? { |num| [1, 2, 3, 4, 5].include?(num) } && cards.size < deck.count) ? break : (p "Please enter card numbers in the range of 1-5.")
    end
    @hand.remove_cards(cards)
    @hand.draw_cards(deck, cards.size)  
  end

  def raise_bet(game)
    bet = 0
    loop do
      p "Please enter a bet higher than the current bet - #{game.current_bet}."
      bet = gets.chomp.to_i
      (bet >= game.current_bet && bet <= @pot) ? break : (p "Please enter a higher bet.")
    end
    game.current_bet = bet
    game.pot += bet
    @pot -= bet
  end
  
  def fold_cards
    @folded = !@folded
    p "Your cards are now folded."
  end
  
end