# frozen_string_literal: true

# Represents a game of connect four
class ConnectFour
  def initialize(player1, player2)
    @board = Array.new(42)
    @players = [player1, player2]
    @current_player = player1
  end

  private

  def select_spot
    choice = gets.chomp.to_i
    @board[choice] = @current_player.marker
  end

  def switch_player
    @current_player =
      @current_player == @players[0] ? @players[1] : @players[0]
  end
end

# Models player attributes for Connect Four game
class Player
  attr_reader :marker, :name

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end
