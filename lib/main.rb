# frozen_string_literal: true

require './lib/connect_four'

player1 = Player.new('Player 1', 'X')
player2 = Player.new('Player 2', 'O')

ConnectFour.new(player1, player2).play
