require 'dotenv/load'
require 'bundler'
require 'paralleldots'
Bundler.require

require_relative 'models/model.rb'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/result' do
    # puts params
    @user_mood = params[:mood]
    get_mood(@user_mood)
    genres($moods)
    @movie = Movie.new # creates an instance of the movie class
    @movie.get_movies_by_genre(@movie.get_genre_id(@genre_list)) # finds the genre id based on the list of genres in the array, then finds a list of movies
    @movie.get_info(@movie_arr) # gets all the info for each movie (title, poster, rating, etc.)
    erb :result
  end
end
