require 'spec_helper'

module Codebreaker
  RSpec.describe UI do

    let(:game) { Game.new }

    context '#save_score' do
      let(:file) { 'file.txt' }
      before { File.new(file, 'w') }
      after { File.delete(file) }

      it 'writes name and score to the file' do
        game.instance_variable_set(:@attempts_used, 5)
        game.instance_variable_set(:@attempts, 6)
        subject.save_score('Test user', file)
        expect(File.zero?(file)).to be false
      end
    end

    describe '#again?' do

      context 'when input is y' do
        it 'calls play' do
          allow(subject).to receive(:again).and_return('y')
          expect(subject).to receive(:play)
          subject.play
        end
      end

      context 'when input is n' do
        it 'should exit' do
          allow(subject).to receive(:again).and_return('n')
          expect(subject).to receive(:bye)
          subject.bye
        end
      end

      context 'when input is s' do
        it 'saves score' do
          allow(subject).to receive(:again).and_return('s')
          expect(subject).to receive(:ask_name)
          subject.ask_name
          expect(subject).to receive(:save_score)
          subject.save_score
          expect(subject).to receive(:again?)
          subject.again?
        end
      end

      context 'when input is different' do
        it 'saves score and exit' do
          allow(subject).to receive(:again).and_return('m')
          expect(subject).to receive(:save_score)
          subject.save_score
          expect(subject).to receive(:bye)
          subject.bye
        end
      end
    end

    describe '#hint' do
      before do
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      end

      it 'calls game#hint' do
        expect(game).to receive(:hint)
        game.hint
      end

      context 'when number is already shown' do
        before do
          index = 2
          secret_code = game.instance_variable_get(:@secret_code)
          subject.instance_variable_set(:@hints, [secret_code[index]])
        end

        it 'calls hint' do
          expect(subject).to receive(:hint)
          subject.hint
        end
      end

      context "when number isn't shown yet" do
        it 'adds chosen number to hints array' do
          hint = subject.instance_variable_get(:@hints) << 2
          expect(hint).to eq([2])
        end

        it 'calls enter_number' do
          expect(subject).to receive(:enter_number)
          subject.enter_number
        end
      end
    end
  end
end
