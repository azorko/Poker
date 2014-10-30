require_relative 'card'

# Represents a deck of playing cards.
class Deck
  attr_accessor :cards
  # Returns an array of all 52 playing cards.
  def self.all_cards
    suits = Card.suits
    values = Card.values
    deck = []
    suits.each do |suit|
      13.times { |val| deck << Card.new(suit, values[val]) }
    end
    deck
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  # Returns the number of cards in the deck.
  def count
    @cards.size
  end

  # Takes `n` cards from the top of the deck.
  def take(n)
    raise ArgumentError.new "Can't take this many cards" if count < n
    @cards.shift(n)
  end

  # Returns an array of cards to the bottom of the deck.
  def return(cards)
    @cards.concat(cards)
  end
  
  def empty?
    count == 0
  end
  
  def shuffle!
    @cards.shuffle!
  end
  
end