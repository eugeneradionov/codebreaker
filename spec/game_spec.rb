require 'spec_helper'

module Codebreaker
  RSpec.describe Game do

    let(:game) { Game.new }
    context '#start' do

      before do
        game.start
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/^[1-6]{4}$/)
      end
    end

    context '#enter_number' do

      before do
        allow(game).to receive(:gets).and_return('1234')
        allow(game).to receive(:puts) { 'Please enter your number' }
        game.enter_number
      end

      it 'saves input only with 4 numbers from 1 to 6' do
        expect(game.instance_variable_get(:@input)).to match(/^[1-6]{4}$/)
      end
    end

    context '#check' do

      before do
        allow(game).to receive(:puts) { 'Please enter your number' }
        allow(game).to receive(:gets).and_return('1234')
        game.enter_number
      end

      context 'when did not guessed exactly' do
        it 'returns string of +-' do
          game.instance_variable_set(:@secret_code, '4321')
          expect(game.check).to match(/^[+-]*$/)
        end
      end

      context 'when exactly guessed' do
        it 'returns 1' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.check).to eq(1)
        end
      end
    end

    context '#play' do
      before do
        allow(game).to receive(:puts).and_return('Menu')
        allow(game).to receive(:gets).and_return('1')
        allow(game).to receive(:gets).and_return('1234')
      end

      context 'when choice is 1' do
        it 'plays' do
          expect(game).to receive(:play)
          game.play
        end
      end

      context 'when choice is 0' do
        it 'should exit' do
          expect(game).to receive(:bye)
          game.bye
        end
      end

      it 'has more than 0 attempts' do
        game.instance_variable_set(:@secret_code, '1234')
        game.play
        expect(game.instance_variable_get(:@attempts)).to be > 0
      end

      context 'when secret code exactly guessed' do
        it 'wins' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.play).to eq(1)
        end
      end

      context 'when attempts is over' do
        it 'looses' do
          game.instance_variable_set(:@secret_code, '4321')
          expect(game.play).to eq(-1)
        end
      end

      context 'either win or loose' do
        it 'ends' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.play.class).to eq(Integer)
          game.instance_variable_set(:@secret_code, '4321')
          expect(game.play.class).to eq(Integer)
        end
      end
    end

    context '#go' do
      before do
        allow(game).to receive(:puts) { 'Win/lose message' }
      end

      it 'calls play' do
        expect(game).to receive(:play)
        game.play
      end

      it 'calls again?' do
        expect(game).to receive(:again?)
        game.again?
      end
    end

    context '#save_score' do
      let(:file) { 'file.txt' }
      before { File.new(file, 'w') }
      after { File.delete(file) }

      it 'writes name and score to the file' do
        game.instance_variable_set(:@attempts_used, 5)
        game.instance_variable_set(:@attempts, 6)
        game.save_score('Test user', file)
        expect(File.zero?(file)).to be false
      end
    end

    context '#again?' do
      before do
        allow(game).to receive(:puts) { 'Do you want to play again?(y/n/s)' }
      end

      context 'when input is y' do
        it 'calls go' do
          allow(game).to receive(:gets) { 'y' }
          expect(game).to receive(:go)
          game.go
        end
      end

      context 'when input is n' do
        it 'should exit' do
          expect(game).to receive(:bye)
          game.bye
        end
      end

      context 'when input is s' do
        it 'saves score' do
          allow(game).to receive(:gets) { 's' }
          expect(game).to receive(:save_score)
          game.save_score
        end
      end

      context 'when input is different' do
        it 'saves score and exit' do
          allow(game).to receive(:gets) { 'm' }
          expect(game).to receive(:save_score)
          game.save_score
          expect(game).to receive(:bye)
          game.bye
        end
      end
    end

    context '#hint' do
      before do
        game.instance_variable_set(:@secret_code, '1234')
      end

      context 'when number is already shown' do
        before do
          game.instance_variable_set(:@hint, ['1'])
        end

        it 'calls hint' do
          expect(game).to receive(:hint)
          game.hint
        end
      end

      context "when number isn't shown yet" do
        it 'adds chosen number to hints array' do
          hint = game.instance_variable_get(:@hints) << '1'
          expect(hint).to eq(['1'])
        end

        it 'calls enter_number' do
          expect(game).to receive(:enter_number)
          game.enter_number
        end
      end
    end
  end
end
