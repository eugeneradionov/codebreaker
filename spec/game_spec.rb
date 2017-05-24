require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#start' do
      let(:game) { Game.new }

      before do
        game.start
      end

      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]{4}/)
      end
    end
    
    context '#get_number' do
      let(:game) { Game.new }

      before do
        allow(game).to receive(:gets).and_return('1234')
        game.get_number
      end

      it 'saves input only with 4 numbers from 1 to 6' do
        expect(game.instance_variable_get(:@input)).to match(/^[1-6]{4}$/)
      end
    end

    context '#check' do
      let(:game) { Game.new }

      before do
        allow(game).to receive(:gets).and_return('1234')
        game.get_number
      end

      it 'when did not guessed exactly' do # returns a string of pluses/minuses or empty
        game.instance_variable_set(:@secret_code, '4321')
        expect(game.check).to match(/^[+-]*$/)
      end

      it 'when exactly guessed' do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.check).to eq(1)
      end
    end
  end
end
