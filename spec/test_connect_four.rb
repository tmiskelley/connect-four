# frozen_string_literal: true

require './lib/connect_four'

describe ConnectFour do
  describe '#select_row' do
    let(:player1) { instance_double(Player, name: 'player1', marker: 'X') }
    let(:player2) { instance_double(Player, name: 'player2', marker: 'O') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when player 1 selects a row' do
      before do
        allow(connect_four).to receive(:gets).and_return('3') # player input
      end

      it "updates the bottom most spot to player 1's marker" do
        connect_four.send(:select_row)
        board = connect_four.instance_variable_get(:@board)
        expect(board[38]).to eq(player1.marker)
      end
    end

    context 'when player 2 selects a row' do
      before do
        players = connect_four.instance_variable_get(:@players)
        connect_four.instance_variable_set(:@current_player, players[1])
        allow(connect_four).to receive(:gets).and_return('3') # player input
      end

      it "updates the bottom most spot to player 2's marker" do
        connect_four.send(:select_row)
        board = connect_four.instance_variable_get(:@board)
        expect(board[38]).to eq(player2.marker)
      end
    end

    context 'when player selects a row that has markers in it' do
      before do
        array = Array.new(42)
        array.map!.with_index { |_e, i| 'X' unless !(i % 7).zero? || i.zero? }
        connect_four.instance_variable_set(:@board, array)
        allow(connect_four).to receive(:gets).and_return('0')
      end

      it "updates the nearest bottom spot to player's marker" do
        connect_four.send(:select_row)
        board = connect_four.instance_variable_get(:@board)
        expect(board[0]).to eq(player1.marker)
      end
    end

    context 'when player enters an invalid input' do
      before do
        allow(connect_four).to receive(:gets).and_return('a', '4')
      end

      it 'returns error message' do
        error_message = 'Invalid input, please enter a valid number'
        expect(connect_four).to receive(:puts).with(error_message).once
        connect_four.send(:select_row)
      end
    end

    context 'when player enters a number outside of board range' do
      before do
        allow(connect_four).to receive(:gets).and_return('-10', '10', '4')
      end

      it 'returns error message' do
        error_message = 'Invalid input, please enter a valid number'
        expect(connect_four).to receive(:puts).with(error_message).twice
        connect_four.send(:select_row)
      end
    end

    context 'when player selects a spot that has already been taken' do
      before do
        filled_array = Array.new(42)
        filled_array[4] = 'X'
        connect_four.instance_variable_set(:@board, filled_array)
        allow(connect_four).to receive(:gets).and_return('4', '5')
      end

      it 'returns error message' do
        error_message = 'This row is already full! Please select a different row'
        expect(connect_four).to receive(:puts).with(error_message).once
        connect_four.send(:select_row)
      end
    end
  end

  describe '#player_win?' do
    let(:player1) { instance_double(Player, name: 'player1', marker: 'X') }
    let(:player2) { instance_double(Player, name: 'player2', marker: 'O') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when current player has not made a line of four in a row' do
      it 'returns false' do
        result = connect_four.send(:horizontal_win?)
        expect(result).to be false
      end
    end
  end

  describe '#horizontal_win?' do
    let(:player1) { instance_double(Player, name: 'player1', marker: 'X') }
    let(:player2) { instance_double(Player, name: 'player2', marker: 'O') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when a horizontal line of four in a row is on board' do
      before do
        win_array = Array.new(42)
        win_array.map!.with_index { |_e, i| 'X' if i.between?(36, 39) }
        connect_four.instance_variable_set(:@board, win_array)
      end

      it 'returns true' do
        result = connect_four.send(:horizontal_win?)
        expect(result).to be true
      end
    end

    context 'when a horizontal edge case is encountered' do
      before do
        win_array = Array.new(42)
        win_array.map!.with_index { |_e, i| 'X' if i.between?(33, 36) }
        connect_four.instance_variable_set(:@board, win_array)
      end

      it 'ignores and returns false' do
        result = connect_four.send(:horizontal_win?)
        expect(result).to be false
      end
    end
  end

  describe '#vertical_win?' do
    let(:player1) { instance_double(Player, name: 'player1', marker: 'X') }
    let(:player2) { instance_double(Player, name: 'player2', marker: 'O') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when a vertical line of four in a row is on board' do
      before do
        win_array = Array.new(42)
        win_array.map!.with_index { |_e, i| 'X' if i.between?(17, 38) && (i % 7) == 3 }
        connect_four.instance_variable_set(:@board, win_array)
      end

      it 'returns true' do
        result = connect_four.send(:vertical_win?)
        expect(result).to be true
      end
    end
  end

  describe '#board_full?' do
    let(:player1) { double('player1') }
    let(:player2) { double('player2') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when board has available spaces' do
      it 'returns false' do
        result = connect_four.send(:board_full?)
        expect(result).to be false
      end
    end

    context 'when the board is full' do
      before do
        full_array = Array.new(42).map.with_index { |_e, i| i.even? ? 'X' : 'O' }
        connect_four.instance_variable_set(:@board, full_array)
      end

      it 'returns true' do
        result = connect_four.send(:board_full?)
        expect(result).to be true
      end
    end
  end

  describe '#switch_player' do
    let(:player1) { double('player1') }
    let(:player2) { double('player2') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when the current player is player 1' do
      it 'switches to player 2' do
        connect_four.send(:switch_player)
        current_player = connect_four.instance_variable_get(:@current_player)
        expect(current_player).to eq(player2)
      end
    end

    context 'when the current player is player 2' do
      before do
        players = connect_four.instance_variable_get(:@players)
        connect_four.instance_variable_set(:@current_player, players[1])
      end

      it 'switches current player to player 1' do
        connect_four.send(:switch_player)
        current_player = connect_four.instance_variable_get(:@current_player)
        expect(current_player).to eq(player1)
      end
    end
  end
end
