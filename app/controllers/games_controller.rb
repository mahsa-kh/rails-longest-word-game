require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []

    for i in (0..13) do
      @letters << ('a'..'z').to_a[rand(26)].upcase
    end
    @letters
  end


#############  READ API TO CHECK IF WORD IS VALID ENGLISH WORD  ##############

def api_valid_word?(variable)
  url = "https://wagon-dictionary.herokuapp.com/#{variable}"
  wagon_dictionary_serialized = open(url).read
  dictionary = JSON.parse(wagon_dictionary_serialized)

  valid_attempt = dictionary['found']
  return valid_attempt
end

##################  READ API TO CHECK OTHER POSSIBLE WORDS #####################

def api_other_options(variable)
  url_auto = "https://wagon-dictionary.herokuapp.com/autocomplete/#{variable}"
  auto_dictionary_serialized = open(url_auto).read
  auto_words = JSON.parse(auto_dictionary_serialized)

  sorted_words = auto_words['words'].max_by(auto_words['words'].length) { |word| word.length }
  return sorted_words
end

def match_grid?(attempt, grid)
  # @answer.chars.all? { |letter| @answer.count(letter) <= @letters.count(letter) } ? check_count = true : check_count = false
  attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) } ? true : false
end


################## RUN GAME ########################################
def run_game(attempt, grid, start_time, end_time)
  @result = {
      time: 0,
      score: 0,
      message: "These letters are not valid!"
    }
  @result[:time] = (end_time - start_time) / 1200

  if match_grid?(attempt.upcase, grid)
    if api_valid_word?(attempt)
      @result[:score] = (attempt.length * 2) + ((@result[:time].to_i * -1) + 50)
      if @result[:score] < 10
        @result[:message] = "Was ok"
      elsif @result[:score] < 20
        @result[:message] = "good"
      elsif @result[:score] < 30
        @result[:message] = "Well Done"
      else
        @result[:message] = "well done"
      end
    else
      @result[:score] = 0
      @result[:message] = "not an english word"
    end
  end
  return @result
end

  def score
    @end_time = Time.now
    @start_time = params[:time].to_i
    @answer = params[:word]
    @letters = params[:quizletters]
    @score = run_game(@answer, @letters, @start_time, @end_time.to_i)
  end
end











  # time_score_counter = 0
  # length_score_counter = 0
  # diff_length = api_other_options(attempt)[0].length - attempt.length


  # case diff_length
  # when 0
  #   length_score_counter = 10 * attempt.length.to_i
  # when 1
  #   length_score_counter = 9 * attempt.length.to_i
  # when 2
  #   length_score_counter = 8 * attempt.length.to_i
  # when 3
  #   length_score_counter = 7 * attempt.length.to_i
  # when 4
  #   length_score_counter = 6 * attempt.length.to_i
  # when 5
  #   length_score_counter = 5 * attempt.length.to_i
  # else
  #   length_score_counter = 4 * attempt.length.to_i
  # end

  # if result[:time] < 5
  #   time_score_counter = 10
  # elsif result[:time] < 10
  #   time_score_counter = 9
  # elsif result[:time] < 15
  #   time_score_counter = 8
  # elsif result[:time] < 20
  #   time_score_counter = 7
  # elsif result[:time] < 30
  #   time_score_counter = 6
  # elsif result[:time] < 59
  #   time_score_counter = 5
  # else
  #   time_score_counter = 0
  # end
