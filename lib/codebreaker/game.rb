module Codebreaker
  class Game
    def initialize
      @secret_code = ''
      @hints = []
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
      @input = gets.chomp
      @input = @input[/^h$/] || @input[/^[1-6]{4}$/]

      if @input =~ /^h$/
        hint
        return
      end

      unless @input =~ /^[1-6]{4}$/
        puts 'Please enter one four-digit number which consist of numbers from 1 to 6.'
        enter_number
      end
    end

    def hint
      number = @secret_code[rand(4)]

      if @hints.include? number
        hint
      else
        @hints << number
        puts "One of the numbers is: #{number}"
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
      choice = gets.chomp[/[10]/]
      exit(0) if choice.to_i.zero?
      puts 'You can use hint by typing h.'

      @attempts = 5
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
          @secret_code = ''
          go
        when 'n'
          bye
        when 's'
          puts 'What is your name?'
          name = gets.chomp
          save_score(name)
          again?
        else
          save_score
          puts 'Your score was saved.'
          bye
      end
    end

    def save_score(name = 'Unknown', file_name = 'codebreaker_score.txt')
      score = (1 / (@attempts_used.to_f / @attempts * 100)).round(2)
      File.new(file_name, 'w') unless File.exist?(file_name)
      File.open(file_name, 'w') do |file|
        file.write("CODEBREAKER SCORE\n")
        file.write("Name: #{name}\n")
        file.write("Score: #{score}%\n")
      end
    end

    def go
      puts "\tWelcome to CODEBREAKER"
      if play > 0
        puts 'You won!'
      else
        puts 'You lost!'
      end

      again?
    end

    def bye
      puts 'Bye!'
      sleep(0.25)
      exit 0
    end
  end
end
