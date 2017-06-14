module Codebreaker
  require_relative 'ui'

  INPUT_REGEX = /^[1-6]{4}$/
  HINT_REGEX = /^h$/
  class Game
    ATTEMPTS = 5
    def initialize
      @hints = []
    end

    def start
      @secret_code = Array.new(4) { rand(1..6) }
      @hints = []
    end

    def enter_number
      @input = UI.enter_number
      @input = @input[HINT_REGEX] || @input[INPUT_REGEX]

      if @input =~ HINT_REGEX && @hints.size < 4
        hint
      elsif @hints.size == 4
        UI.all_hints_used(@secret_code.join)
        again?
      end

      unless @input =~ INPUT_REGEX || HINT_REGEX
        UI.invalid_input
        enter_number
      end
    end

    def hint
      index = rand(4)
      number = @secret_code[index]

      if @hints.include? index
        hint
      else
        @hints << index
        UI.hint(number)
        enter_number
      end
    end

    def check
      input_array = @input.split('').map(&:to_i)
      return '++++' if input_array == @secret_code

      zipped = @secret_code.zip(input_array).delete_if { |el| el[0] == el[1] }
      pluses = @secret_code.size - zipped.size

      zipped = zipped.transpose
      secret_array = zipped[0]
      input_array = zipped[1]

      input_array.each do |el|
        secret_array.delete_at(secret_array.index(el)) if secret_array.include? el
      end
      minuses = @secret_code.size - pluses - secret_array.size

      '+' * pluses + '-' * minuses
    end

    def play
      start
      UI.choice
      UI.won_or_lost?(attempt)
      again?
    end

    def go
      UI.caption
      play
    end

    def attempt
      @attempts_used = 0
      ATTEMPTS.times do
        enter_number
        @attempts_used += 1
        check_result = check
        return 1 if check_result == '++++'
        puts check_result
      end
      return -1
    end

    def again?
      choice = UI.again

      case choice
        when 'y'
          play
        when 'n'
          UI.bye
        when 's'
          name = UI.ask_name
          save_score(name)
          again?
        else
          save_score
          UI.score_saved
          UI.bye
      end
    end

    def save_score(name = 'Unknown', file_name = 'codebreaker_score.txt')
      score = (ATTEMPTS - @attempts_used) * 1000 + 1000
      File.new(file_name, 'w') unless File.exist?(file_name)
      File.open(file_name, 'w') do |file|
        file.write("CODEBREAKER SCORE\n")
        file.write("Name: #{name}\n")
        file.write("Score: #{score}\n")
      end
    end
  end
end
