require 'open-uri'
require 'json'
require 'pry-byebug'

class GamesController < ApplicationController

  def new
    @grid_array = []
    @grid_array << ('A'..'Z').to_a.sample until @grid_array.length == 10
  end

  def score
    @word = params[:word]
    @passed_array = params[:grid_array]
    @result = nil
    # @result = "<strong>Congratulation!</strong> #{@word} is a valid English word!"
    @result = if check_word(@word.downcase)
                check_grid(@passed_array, @word)
              else
                "Sorry but #{@word} does not seem to be a valid English word."
              end
  end

  def check_grid(grid_array, word)
    array_check = []
    @grid_hash = grid_array.downcase.chars.tally
    @result_hash = @word.downcase.chars.tally
    word.chars.each { |letter| array_check << @grid_hash.keys.include?(letter) }
    if array_check.include?(false) == false
      "Congratulation! #{word} is a valid English word!"
    else
      "Sorry but #{word} cannot be built out of #{grid_array.chars.join(', ')}"
    end
    # if @grid_hash.keys - @word.chars.uniq == []
    #   "Your word is #{@word}"
    # else
    #   'Your letters are not in the grid!'
    # end
  end

  def check_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    # answer_serialized = URI.open(url).read
    answer_serialized = URI.parse(url).open.read
    answer = JSON.parse(answer_serialized)
    answer['found']
  end
end
