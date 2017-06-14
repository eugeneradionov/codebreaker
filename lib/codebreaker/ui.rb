module UI
  extend self
  def menu
    puts "1.Start\n"\
           "0.Exit\n"
  end

  def again
    puts 'Do you want to play again(y/n) or save score(s)?'
    gets.chomp.downcase[/^[yns]/]
  end

  def score_saved
    puts 'Your score was saved.'
  end

  def ask_name
    puts 'What is your name?'
    gets.chomp
  end

  def enter_number
    puts 'Please enter your number'
    gets.chomp
  end

  def invalid_input
    puts 'Please enter one four-digit number which consist of numbers from 1 to 6.'
  end

  def hint(number)
    puts "One of the numbers is: #{number}"
  end

  def all_hints_used(secret_code)
    puts "You have used all hints. The number is #{secret_code}."
  end

  def choice
    menu
    choice = gets.chomp[/[10]/]
    bye if choice.to_i != 1
    puts 'You can use hint by typing h.'
  end

  def bye
    puts 'Bye!'
    sleep(0.25)
    exit 0
  end

  def caption
    puts "\tWelcome to CODEBREAKER"
  end

  def won_or_lost?(attempt)
    if attempt > 0
      puts 'You won!'
    else
      puts 'You lost!'
    end
  end
end
