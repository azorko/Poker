require 'rspec'
require 'deck'

describe "Deck" do
  let(:deck) { Deck.new }
  describe "::all_cards" do
    it "returns all 52 cards in a deck" do
      expect(Deck.all_cards.size).to eq(52)
    end
    
    it "should return 13 of each suit" do
      clubs = Deck.all_cards.select { |card| card.suit == :clubs }
      expect(clubs.size).to eq(13)
    end
    
    it "should have 4 of each kind of value" do
      deuces = Deck.all_cards.select { |card| card.value == :deuce }
      expect(deuces.size).to eq(4)
    end
  end
  
  describe "::initialize" do 
    it "should create a deck of cards" do
      deck = Deck.new
      rand = (0..51).to_a.sample
      expect(deck.cards[rand]).to be_an_instance_of(Card)
    end
  end
  
  describe ".take" do
    
    let(:cards) { deck.take(3) }
      
    it "should remove n cards from the top (begin of array) of deck" do
      deck.take(3)
      expect(deck.count).to eq(49)
    end
    
    it "should return n cards" do
      expect(cards.count).to eq(3)
    end
    
    it "should raise an error if there are not enough cards to take n" do
      expect{deck.take(53)}.to raise_error(ArgumentError, "Can't take this many cards")
    end
  end
  
  describe ".return" do
    let(:cards) { [Card.new(:clubs, :deuce), Card.new(:hearts, :three)] }
    let(:deck) { Deck.new }
    it "should return the given array of cards to the top of the cards array" do
      deck.return(cards)  
      expect(deck.cards[-2..-1]).to eq(cards)
    end
  end
end