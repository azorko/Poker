# require_relative 'deck'
require 'byebug'

##only problem if same pair value, then hand wins based on what?

class Hand
  
  HAND_TYPE = Hash[:straight_flush, 0, :four_kind, 1, :full_house, 2, 
                  :flush, 3, :straight, 4, :three_kind, 5, :two_pair, 6,
                  :one_pair, 7, :high_card, 8]
  
  
  
  def self.deal_from(deck, player_ind)
    Hand.new(deck.take(5), player_ind)
  end

  attr_accessor :cards, :hand_type, :player_ind

  def initialize(cards, player_ind)
    @cards = cards
    @player_ind = player_ind
  end
  
  def draw_cards(deck, num)
    @cards.concat(deck.take(num))
  end
  
  ##removed cards do not get added back to the deck
  def remove_cards(to_remove)
    to_remove.each { |num| @cards.delete_at(num - 1) }
  end
  
  #assume that the hand is reverse sorted beforeheand
  def straight?
    len = @cards.size - 1
    (0...len).each do |i|
      return false unless @cards[i].poker_val == @cards[i + 1].poker_val + 1
    end
    true
  end
  
  #returns [value of card, number of cards of that value]
  def same_val
    # debugger 
    val_counter = Hash.new { |h, k| h[k] = 0 }
    @cards.each do |card| 
      val_counter[card.poker_val] += 1
    end
    result = val_counter.max_by { |key, val| val}
  end
  
  def fh_or_tp
    val_counter = Hash.new { |h, k| h[k] = 0 }
    @cards.each { |card| val_counter[card.poker_val] += 1 }
    val_counter.select! { |k, v| v > 1 }
    return :full_house if val_counter.values.sort == [2, 3]
    return :two_pair if val_counter.values.sort == [2, 2]
  end
  
  def flush?
    suit = @cards.last.suit
    @cards.all? { |card| card.suit == suit }
  end
  
  def assign_hand_type
    return :straight_flush if straight? && flush? 
    return :four_kind if same_val.last == 4
    return :full_house if fh_or_tp == :full_house
    return :flush if flush?
    return :straight if straight?
    return :three_kind if same_val.last == 3
    return :two_pair if fh_or_tp == :two_pair
    return :one_pair if same_val.last == 2
    return :high_card
  end
  
  
  #need to be able to handle ties
  def self.best_hand(hands)
    hands.each do |hand|
      hand.hand_type = HAND_TYPE[hand.assign_hand_type]
    end
    hands = hands.sort_by { |hand| hand.hand_type }.to_a
    min = hands.first.hand_type 
    hands.select! { |hand| hand.hand_type == min }
     
    return hands.first if hands.size == 1
    return Hand.high_card(hands) if [0, 3, 4, 8].include?(hands.first.hand_type)
    return Hand.x_of_a_kind(hands) if [1, 5, 7].include?(hands.first.hand_type)
    return Hand.best_fh(hands) if hands.first.hand_type == 2
    return Hand.best_tp(hands) if hands.first.hand_type == 6
  end
  
  def self.high_card(hands)
    hands = hands.max_by { |hand| hand.cards.first.poker_val}
  end
  
  def self.x_of_a_kind(hands)
    #[value, counter]
    hands = hands.max_by { |hand| hand.same_val.first }
  end
  
  def self.best_fh(hands)
    high_card_arr = []
    hands.each do |hand|
      val_counter = Hash.new { |h, k| h[k] = 0 }
      hand.cards.each { |card| val_counter[card.poker_val] += 1 }
      high_card_arr << val_counter.select! { |k, v| v == 3 }.keys.first
    end
    hands[high_card_arr.each_with_index.max.last]
  end
  
  def self.best_tp(hands)
    high_card_arr = []
    hands.each do |hand|
      val_counter = Hash.new { |h, k| h[k] = 0 }
      hand.cards.each { |card| val_counter[card.poker_val] += 1 }
      high_card_arr << val_counter.select! { |k, v| v == 2 }.keys.max
    end
    hands[high_card_arr.each_with_index.max.last]
  end
  
  def to_s
    @cards.each_with_index.map do |card, ind|
      "#{ind + 1}: #{card.to_s}"
    end.join(',')
  end
  
end
# deck = Deck.new
# deck.cards.shuffle!
# cards = deck.take(5)
# cards = cards.sort_by { |card| card.poker_val }.to_a.reverse!
# hand1 = Hand.new(cards)
# next_cards = deck.take(5)
# next_cards = next_cards.sort_by { |card| card.poker_val }.to_a.reverse!
# hand2 = Hand.new(next_cards)
#
# hands = [hand1, hand2]
# p "Best card"
# p Hand.best_hand(hands).to_s
# p hand1.assign_hand_type
# p hand1.to_s
# p hand2.assign_hand_type
# p hand2.to_s