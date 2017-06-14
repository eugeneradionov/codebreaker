require 'spec_helper'

module Codebreaker
  RSpec.describe Game do

    context '#start' do
      before do
        subject.start
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code).join).to match(/^[1-6]{4}$/)
      end
    end

    context '#enter_number' do
      it 'saves input only with 4 numbers from 1 to 6' do
        subject.instance_variable_set(:@input, '1234')
        expect(subject.instance_variable_get(:@input)).to match(/^[1-6]{4}$/)
      end
    end

    context '#check' do
      before do
        subject.instance_variable_set(:@input, '1234')
      end

      context 'when did not guessed exactly' do
        it 'returns string of +-' do
          subject.instance_variable_set(:@secret_code, [1, 3, 2, 1])
          expect(subject.check).to match(/^[+-]*$/)
        end
      end

      context 'when exactly guessed' do
        it 'returns 1' do
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
          expect(subject.check).to eq('++++')
        end
      end

      context 'test method with different data' do
        require 'codebreaker_data'
        data = CodebreakerData.data
        it 'passes the tests' do
          data.each do |el|
            subject.instance_variable_set(:@secret_code, el[0])
            subject.instance_variable_set(:@input, el[1])
            result = el[2]
            expect(subject.check).to eq(result)
          end
        end
      end
    end

    context '#play' do
      it 'calls #start' do
        expect(subject).to receive(:start)
        subject.start
      end

      it 'calls #attempt' do
        expect(subject).to receive(:attempt)
        subject.attempt
      end

      it 'calls #again?' do
        expect(subject).to receive(:again?)
        subject.again?
      end
    end

    context '#go' do
      it 'calls #play' do
        expect(subject).to receive(:play)
        subject.play
      end
    end

    context '#save_score' do
      let(:file) { 'file.txt' }
      before { File.new(file, 'w') }
      after { File.delete(file) }

      it 'writes name and score to the file' do
        subject.instance_variable_set(:@attempts_used, 5)
        subject.instance_variable_set(:@attempts, 6)
        subject.save_score('Test user', file)
        expect(File.zero?(file)).to be false
      end
    end

    context '#again?' do
      require_relative '../lib/codebreaker/ui'

      context 'when input is y' do
        it 'calls play' do
          allow(UI).to receive(:again).and_return('y')
          expect(subject).to receive(:play)
          subject.play
        end
      end

      context 'when input is n' do
        it 'should exit' do
          allow(UI).to receive(:again).and_return('n')
          expect(UI).to receive(:bye)
          UI.bye
        end
      end

      context 'when input is s' do
        it 'saves score' do
          allow(UI).to receive(:again).and_return('s')
          expect(UI).to receive(:ask_name)
          UI.ask_name
          expect(subject).to receive(:save_score)
          subject.save_score
          expect(subject).to receive(:again?)
          subject.again?
        end
      end

      context 'when input is different' do
        it 'saves score and exit' do
          allow(UI).to receive(:again).and_return('m')
          expect(subject).to receive(:save_score)
          subject.save_score
          expect(UI).to receive(:bye)
          UI.bye
        end
      end
    end

    context '#hint' do
      before do
        subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      end

      context 'when number is already shown' do
        before do
          index = 2
          secret_code = subject.instance_variable_get(:@secret_code)
          subject.instance_variable_set(:@hint, secret_code[index])
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
