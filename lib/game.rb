require_relative 'deck'
require_relative 'hand'
require_relative 'player'
require 'byebug'

class Game
  
  attr_accessor :players, :deck, :current_bet, :pot

  def initialize
    @hands = []
    @deck = Deck.new
    @deck.shuffle!
    @players = []
    @pot = 0
    @current_bet = 0 #current highest bet
  end
  
  def add_players
    p "How many players, (up to 5):"
    input = gets.chomp.to_i
    input.times do |i|
      @players << Player.new("Player #{i + 1}", Hand.deal_from(@deck, i))
    end
  end
  
  
  #game over if only 1 player not folded, or if players run out of pot to bet
  def game_over?
    @hands.size == 1 || @players.all? { |player| player.pot == 0  || player.folded } 
  end
  
  def play
    add_players
    until game_over?
      @hands = []
      @players.each do |player|
        unless player.folded
          p "#{player.name}'s turn."
          show_bet
          player.player_turn(self)
          @hands << player.hand unless player.folded #issue if all players fold by end of game
        end
      end
      p "Cards left in deck: #{deck.count}"
    end
    @players.each_with_index { |player, i| p "#{player.name}: #{player.hand.to_s}" }
    unless @hands.empty?
      winner_ind = Hand.best_hand(@hands).player_ind
      p "Player #{winner_ind + 1} won the round and their winning pot is #{@pot}."
      @players[winner_ind].receive_winnings(@pot)
      p "Game end scores:"
      @players.each { |player| p "#{player.name} pot: #{player.pot}." }
    else
      p "Everybody folded, lame!"
    end
  end
  
  def show_bet
    p "The current highest bet is #{@current_bet}"
  end

end

g = Game.new
g.play