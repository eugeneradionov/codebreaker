require 'spec_helper'

module Codebreaker
  RSpec.describe Game do

    let(:game) { Game.new }
    context '#start' do

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

      it 'when did not guessed exactly' do
        game.instance_variable_set(:@secret_code, '4321')
        expect(game.check).to match(/^[+-]*$/)
      end

      it 'when exactly guessed' do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.check).to eq(1)
      end
    end

    context '#play' do

      before do
        allow(game).to receive(:puts).and_return('Menu')
        allow(game).to receive(:gets).and_return('1')
        allow(game).to receive(:gets).and_return('1234')
      end

      it 'plays when choice 1' do
        expect(game).to receive(:play)
        game.play
      end

      it 'should exit when choice 0'

      it 'has more than 0 attempts' do
        game.instance_variable_set(:@secret_code, '1234')
        game.play
        expect(game.instance_variable_get(:@attempts)).to be > 0
      end

      it 'wins when secret code exactly guessed', :win do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.play).to eq(1)
      end

      it 'looses when attempts is over' do
        game.instance_variable_set(:@secret_code, '4321')
        expect(game.play).to eq(-1)
      end

      it 'ends either win or loose' do
        game.instance_variable_set(:@secret_code, '1234')
        expect(game.play.class).to eq(Integer)
        game.instance_variable_set(:@secret_code, '4321')
        expect(game.play.class).to eq(Integer)
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

      it 'calls go when input is y' do
        allow(game).to receive(:gets) { 'y' }
        expect(game).to receive(:go)
        game.go
      end

      it 'should exit when input is n'

      it 'saves score when input is s' do
        allow(game).to receive(:gets) { 's' }
        expect(game).to receive(:save_score)
        game.save_score
      end

      it 'saves score and exit when input is different' do
        allow(game).to receive(:gets) { 'h' }
        expect(game).to receive(:save_score)
        game.save_score
        # game.bye
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
