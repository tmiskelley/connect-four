# frozen_string_literal: true

require './lib/connect_four'

describe ConnectFour do
  describe '#switch_player' do
    let(:player1) { double('player1') }
    let(:player2) { double('player2') }
    subject(:connect_four) { described_class.new(player1, player2) }

    context 'when the current player is player 1' do
      it 'switches current player to player 2' do
        connect_four.send(:switch_player)
        current_player = connect_four.instance_variable_get(:@current_player)
        expect(current_player).to eq(player2)
      end
    end
  end
end
