module Codebreaker
  class UI
    require_relative 'game'
    INPUT_REGEX = /^[1-6]{4}$/
    HINT_REGEX = /^h$/

    def initialize
      @game = Game.new
      @hints = []
    end

    def go
      puts "\tWelcome to CODEBREAKER"
      play
    end

    def play
      initialize
      choice
      won_or_lost?(attempt)
      again?
    end

    def choice
      menu
      choice = gets.chomp[/^[10]$/]
      bye if choice.to_i != 1
      puts 'You can use hint by typing h.'
    end

    def menu
      puts "1.Start\n"\
             "0.Exit\n"
    end

    def won_or_lost?(attempt)
      puts 'You won!' if attempt
      puts 'You lost!'
    end

    def attempt
      @game.attempts.times do
        @game.input = enter_number
        @game.attempts_used += 1
        check_result = @game.check
        return true if check_result == '++++'
        puts check_result
      end
      nil
    end

    def enter_number
      puts 'Please enter your number'

      input = gets.chomp
      input = input[HINT_REGEX] || input[INPUT_REGEX]

      if input =~ HINT_REGEX && @hints.size < 4
        hint
      elsif @hints.size == 4
        puts 'You have used all hints.'
      end

      unless input =~ INPUT_REGEX || input =~ HINT_REGEX
        invalid_input
        enter_number
      end
      input
    end

    def invalid_input
      puts 'Please enter one four-digit number which consist of numbers from 1 to 6.'
    end

    def hint
      number = @game.hint
      if @hints.include? number
        hint
      else
        @hints << number
        puts "One of the numbers is: #{number}"
        enter_number
      end
    end

    def again?
      puts 'Do you want to play again(y/n) or save score(s)?'
      choice = gets.chomp.downcase[/^[yns]/]

      case choice
        when 'y'
          play
        when 'n'
          bye
        when 's'
          name = ask_name
          save_score(name)
          again?
        else
          save_score
          puts 'Your score was saved.'
          bye
      end
    end

    def save_score(name = 'Unknown', file_name = 'codebreaker_score.txt')
      score = (@game.attempts - @game.attempts_used) * 1000 + 1000
      File.new(file_name, 'w') unless File.exist?(file_name)
      File.open(file_name, 'w') do |file|
        file.write("CODEBREAKER SCORE\n")
        file.write("Name: #{name}\n")
        file.write("Score: #{score}\n")
      end
    end

    def ask_name
      puts 'What is your name?'
      gets.chomp
    end

    def bye
      puts 'Bye!'
      sleep(0.25)
      exit 0
    end
  end
end
