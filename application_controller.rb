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
    @movie_list = get_movies_by_genre(get_genre_id(genres($moods)))[0]
    @movie_list.each do |movie|
      Movie.new(movie) # creates an instance of the movie class
    end
    erb :result
  end
end
