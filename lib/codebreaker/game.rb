module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      4.times { @secret_code << rand(1..6).to_s }
    end

    def get_number
      @input = gets.chomp[/^[1-6]{4}$/]

      unless @input =~ /[1-6]{4}/
        puts 'Please enter one four-digit number which consist of numbers from 1 to 6.'
        get_number
      end
    end

    def check
      secret_array = @secret_code.split('').map(&:to_i)
      input_array = @input.split('').map(&:to_i)

      str = ''
      secret_array.each_index do |i|
        str << '-' if secret_array.include? input_array[i]
        str[i] = '+' if secret_array[i] == input_array[i]
      end
      str = str.chars.sort.join

      return 1 if str == '++++'
      str
    end
  end
end
