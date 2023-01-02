# frozen_string_literal: true

# Represents a game of connect four
class ConnectFour
  def initialize(player1, player2)
    @board = Array.new(42)
    @players = [player1, player2]
    @current_player = player1
  end

  def play
    print "Lets play connect four!\n\n"
    loop do
      display_board
      print "\n#{@current_player.name}: "
      select_row
      break if game_over?

      switch_player
    end
  end

  private

  def display_board
    puts 'Enter a row number to select a spot'

    @board.each_with_index do |e, i|
      print "|\n" if (i % 7).zero? && !i.zero?
      print e.nil? ? '|   ' : "| #{e} "
    end
    print "|\n"
    print "  0   1   2   3   4   5   6  \n"
  end

  def select_row
    choice = validate_entry
    choice += 7 while @board[choice].nil? && (choice < 42)
    choice -= 7
    @board[choice] = @current_player.marker
  end

  def player_win?
    horizontal_win? || vertical_win? || diagonal_win?
  end

  def horizontal_win?
    horizontal_lines = 0
    min, max = 35, 41
    until min.negative?
      @board[min..max].each do |e|
        e == @current_player.marker ? horizontal_lines += 1 : horizontal_lines = 0
        return true if horizontal_lines >= 4
      end
      min -= 7
      max -= 7
      horizontal_lines = 0
    end

    false
  end

  def vertical_win?
    check_board(35, 7)
  end

  # checks board for a left or right facing diagonal
  def diagonal_win?
    # left                # right
    check_board(35, 6) || check_board(35, 8)
  end

  def check_board(current_direction, offset)
    in_a_row = 0
    until current_direction > 41
      current_spot = current_direction
      until current_spot.negative?
        @board[current_spot] == @current_player.marker ? in_a_row += 1 : in_a_row = 0
        return true if in_a_row >= 4

        current_spot -= offset # moves to the next spot
      end
      in_a_row = 0
      current_direction += 1 # moves to the next row in current direction
    end

    false
  end

  def board_full?
    @board.none?(nil)
  end

  def switch_player
    @current_player =
      @current_player == @players[0] ? @players[1] : @players[0]
  end

  # verifies players choice is a number
  def validate_entry
    begin
      choice = Integer(gets.chomp)
    rescue ArgumentError
      invalid_input
    else
      validate_choice(choice)
    end
  end

  # verifies players choice is a vaild row with an open spot
  def validate_choice(choice)
    if !choice.between?(0, 6)
      invalid_input
    elsif !@board[choice].nil?
      puts 'This row is already full! Please select a different row'
      validate_entry
    else
      choice
    end
  end

  def invalid_input
    puts 'Invalid input, please enter a valid number'
    validate_entry
  end

  def game_over?
    game_over_message(true) if player_win?
    game_over_message(false) if board_full?

    player_win? || board_full?
  end

  def game_over_message(winner)
    message = winner ? "#{@current_player.name} wins!" : 'Game tied.'

    display_board
    puts message
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
