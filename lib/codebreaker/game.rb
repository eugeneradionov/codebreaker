module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      4.times { @secret_code << rand(1..6).to_s }
    end

    def menu
      puts "1.Start\n"\
           "0.Exit\n"
    end

    def enter_number
      puts 'Please enter your number'
      @input = gets.chomp[/^[1-6]{4}$/]

      unless @input =~ /[1-6]{4}/
        puts 'Please enter one four-digit number which consist of numbers from 1 to 6.'
        enter_number
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

    def play
      start
      menu
      choice = gets.chomp[/\d/]
      exit(0) if choice.to_i.zero?

      @attempts = 6
      @attempts_used = 0
      @attempts.times do
        enter_number
        @attempts_used += 1
        return 1 if check == 1
        puts check
      end
      return -1
    end

    def again?
      puts 'Do you want to play again(y or n) or save score(s)?'
      choice = gets.chomp.downcase[/^[yns]/]

      case choice
        when 'y'
          go
        when 'n'
          puts 'Bye!'
          sleep(0.5)
          exit 0
        when 's'
          puts 'What is your name?'
          name = gets.chomp
          save_score(name)
        else
          save_score
          puts 'Your score was saved.'
          puts 'Bye!'
          sleep(0.3)
          exit 0
      end
    end

    def save_score(name = 'Unknown', file_name = 'codebreaker_score.txt')
      score = (@attempts_used.to_f / @attempts * 100).round(2)
      File.new(file_name, 'w') unless File.exist?(file_name)
      File.open(file_name, 'w') do |file|
        file.write("CODEBREAKER SCORE\n")
        file.write("Name: #{name}\n")
        file.write("Score: #{score}%\n")
      end
    end

    def go
      if play > 0
        puts 'You won!'
      else
        puts 'You lost!'
      end

      again?
    end
  end
end
