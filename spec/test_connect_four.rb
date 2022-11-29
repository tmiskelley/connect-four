# frozen_string_literal: true

require './lib/connect_four'

describe ConnectFour do
  describe '#select_spot' do
    let(:player1) { instance_double(Player, name: 'player1', marker: 'X') }
    let(:player2) { instance_double(Player, name: 'player2', marker: 'O') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when player 1 selects a spot' do
      before do
        allow(connect_four).to receive(:gets).and_return('3') # player input
      end

      it "updates the spot to player 1's marker" do
        connect_four.send(:select_spot)
        board = connect_four.instance_variable_get(:@board)
        expect(board[3]).to eq(player1.marker)
      end
    end

    context 'when player 2 selects a spot' do
      before do
        players = connect_four.instance_variable_get(:@players)
        connect_four.instance_variable_set(:@current_player, players[1])
        allow(connect_four).to receive(:gets).and_return('3') # player input
      end

      it "updates the spot to player 2's marker" do
        connect_four.send(:select_spot)
        board = connect_four.instance_variable_get(:@board)
        expect(board[3]).to eq(player2.marker)
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
