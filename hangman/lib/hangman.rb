# frozen_string_literal: true
require './save_game.rb'
# class HangMan
class HangMan
  attr_reader :word, :word_array
  attr_accessor :wrong_point, :show_array, :current_word, :same_word, :game_saved

  extend Save

  def initialize
    @game_saved = false
    @wrong_point = 10
    @word = pick_random_word('google-10000-english-no-swears.txt')
    @word_array = word.split('')
    @show_array = Array.new(word_array.length, '_')
    @same_word = []
  end

  def start_game
    while wrong_point != 0
      p show_word
      @current_word = take_input_char
      result_arr = check_input_with_word
      break if game_saved == true
      check_same_word(current_word)
      reduce_wrong_point(result_arr)
      show_wrong_point
      update_show_word(result_arr)
    end
  end

  def take_input_char
    result = ''
    while result.length != 1
      result = gets.chomp
      puts 'error , enter only one char[a-z]' unless result.length == 1
    end
    if result == '1'
      save_game(self) 
      @game_saved = true
    end
    result
  end

  def save_game(obj)
    Save.create_dir
    file_name = Save.make_save_file(obj)
    print "you save your game in #{file_name}" 
  end

  def check_same_word(char)
    if same_word.any?(char)
      puts 'you already entered this char , enter diffrent char'
    else
      same_word.push(char)
    end
  end

  def show_wrong_point
    puts "you have #{@wrong_point} life left"
  end

  def pick_random_word(file_name)
    random_word = ''
    dictionary = File.open(file_name)
    dictionary_size = dictionary.readlines.length

    while random_word.length > 12 || random_word.length < 5
      dictionary.rewind
      random_word = dictionary.readlines[rand(dictionary_size)].chomp
    end
    random_word
  end

  def reduce_wrong_point(arr)
    if arr.empty?
      @wrong_point -= 1
      if wrong_point.zero?
        puts "the real word was #{word}"
        puts 'game over lol'
      end
    end
  end

  def show_word
    show_array
  end

  def check_word_winner
    puts 'hooryyy you are winner' if show_array == word_array
  end

  def update_show_word(arr)
    arr.each do |i|
      show_array[i] = current_word
    end
    show_word
  end

  def check_input_with_word(arr = word_array)
    arr.each_index.select { |i| arr[i] == current_word }
  end
end

game = HangMan.new
game.start_game
