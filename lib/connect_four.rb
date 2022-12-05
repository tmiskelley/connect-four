# frozen_string_literal: true

# Represents a game of connect four
class ConnectFour
  def initialize(player1, player2)
    @board = Array.new(42)
    @players = [player1, player2]
    @current_player = player1
  end

  private

  def display_board
    @board.each_with_index do |e, i|
      print "|\n" if (i % 7).zero? && !i.zero?
      print e.nil? ? '|   ' : "| #{e} "
    end
    print "|\n"
  end

  def select_row
    choice = validate_entry
    choice += 7 while @board[choice].nil? && (choice < 41)
    choice -= 7
    @board[choice] = @current_player.marker
  end

  def switch_player
    @current_player =
      @current_player == @players[0] ? @players[1] : @players[0]
  end

  def validate_entry
    begin
      choice = Integer(gets.chomp)
    rescue ArgumentError
      invalid_input
    else
      validate_choice(choice)
    end
  end

  def validate_choice(choice)
    if !choice.between?(0, 6)
      invalid_input
    elsif !@board[choice].nil?
      puts 'This spot has already been taken! Please select a different spot'
      validate_entry
    else
      choice
    end
  end

  def invalid_input
    puts 'Invalid input, please enter a valid number'
    validate_entry
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
