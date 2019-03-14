require 'paralleldots'
require 'dotenv/load'
require 'pp'
require 'json'
require 'open-uri'

set_api_key(ENV["PARALLEL_API"])

$moods = {
    "happy" => ["Comedy", "Adventure", "Action"],
    "sad" => ["Drama", "Romantic Comedy"],
    "angry" => ["Thriller", "Mystery", "Horror"],
    "excited" => ["Animation", "Kids", "Comedy"],
    "fear" => ["Horror", "Comedy"],
    "bored" => ["Comedy", "Action", "Thriller"]
}

def get_mood(mood)
    @user_mood=emotion(mood)
    @user_mood = @user_mood["emotion"]["emotion"]
end


def genres(moods_hash)
    moods_hash.each do |mood,moods|
        if mood == @user_mood.downcase
            @genre_list = moods
        end
    end
end

class Movie
    attr_reader :title, :poster, :summary, :movie_titles, :movie_posters, :movie_summaries
 
    def initialize
        @movie_titles = []
        @movie_posters = []
        @movie_summaries = []
    end
 
    def get_genre_id(genre)
        genres = JSON.parse(open('https://api.themoviedb.org/3/genre/movie/list?api_key=' + ENV['MOVIE_API']){ |x| x.read })
        genres['genres'].each do |i|
            if genre == i['name']
                return i['id'].to_s
            end
        end
    end

    def get_movies_by_genre(genre)
        movies = JSON.parse(open("https://api.themoviedb.org/3/discover/movie?with_genres="+ get_genre_id(genre) +"&api_key=" + ENV['MOVIE_API']){ |x| x.read })
    end

    def get_info(genre_arr)
        genre_arr.each do |genre|
            @title = get_movies_by_genre(genre)["results"].first["title"]
            @movie_titles << @title
            @poster = get_movies_by_genre(genre)["results"].first["poster_path"]
            @movie_posters << @poster
            @summary = get_movies_by_genre(genre)["results"].first["overview"]
            @movie_summaries << @summary
        end
    end
end