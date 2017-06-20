require 'spec_helper'

module Codebreaker
  RSpec.describe Game do

    describe '#generate_secret_code' do
      it 'returns array with four numbers from 1 to 6' do
        array = subject.generate_secret_code
        expect(array.join). to match(/^[1-6]{4}$/)
      end
    end

    describe '#check' do
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
  end
end
