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

    erb :result
  end
end
