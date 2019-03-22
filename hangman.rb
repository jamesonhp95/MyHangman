class Hangman
  def initialize(dict_fname)
    @alphabet = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
    @dict = Array.new
    @hidden_word = Array.new
    @cur_word = Array.new
    @guesses = 8
    @play_again = false
    @dict_fname = dict_fname

    File.open(dict_fname, "r") do |fin|
      fin.each_line do |line|
        @dict << line
      end
    end
  end

  def choose_word
    @cur_word = @dict[Random.rand(@dict.length)]
    @hidden_word = @cur_word.gsub(/[a-z]|[A-Z]+/, "_")
  end

  def display_hidden
    puts @hidden_word.scan(/./).join(' ')
  end

  def display_alphabet
    @alphabet.join('')
  end

  def validate_guess(input)
    if input.length > 1
      puts "Please enter only a single character"
    elsif @alphabet.include?input
      @alphabet.delete(input)
      if @cur_word.include?input
        puts "You guessed right!"
        x = 0
        while x < @cur_word.length
          if @cur_word[x] == input
            @hidden_word[x] = input
          end
          x = x + 1
        end
      else
        @guesses = @guesses - 1
        puts "You guessed wrong! Lives left: #{@guesses}"
      end
    else
      puts "Please enter a character you haven't guessed yet!"
    end
  end

  def is_playing
    if @guesses <= 0
      puts "I'm sorry, you lost."
      replay
      return @play_again
    end
    if @cur_word == @hidden_word
      puts "You win!!"
      replay
      return @play_again
    end
    puts "Please guess a letter from your current alphabet: "
    puts @alphabet.join(' ')
    display_hidden
    return true
  end

  def replay
    puts "Do you want to play again? (y/n)"
    input = gets.strip.downcase
    if input == "y"
      puts "Starting again!"
      restart
      puts "Please guess a letter from your current alphabet: "
      puts @alphabet.join(' ')
      display_hidden
      @play_again = true
    else
      puts "Thanks for playing!"
      @play_again = false
    end
  end

  def restart
    @alphabet.clear
    @alphabet = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
    @cur_word.clear
    @hidden_word.clear
    choose_word
  end
  
  def print_dict
    puts @dict.join('')
  end

end

hangman = Hangman.new("words.txt")
hangman.choose_word

while hangman.is_playing
  input = gets.strip.downcase
  hangman.validate_guess(input)
end