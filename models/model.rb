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
        @id_arr = []
        genres = JSON.parse(open('https://api.themoviedb.org/3/genre/movie/list?api_key=' + ENV['MOVIE_API']){ |x| x.read })
        genres['genres'].each do |i|
            genre.each do |x|
                if x == i['name']
                    @id_arr.push(i['id'].to_s)
                end
            end
        end
        return @id_arr
    end

    def get_movies_by_genre(genre)
        @movie_arr = []
        genre.each do |id|
            movies = JSON.parse(open("https://api.themoviedb.org/3/discover/movie?with_genres="+ id +"&api_key=" + ENV['MOVIE_API']){ |x| x.read })
            @movie_arr.push(Hash[movies["results"].sort_by { |k,v| v }[0..4]])
        end
    end

    def get_info(genre_arr)
        if @movie_titles.length <= 3 
            @movie_arr.shuffle!
            @movie_arr.each do |movie|
                @title = movie["title"]
                @poster = movie["poster_path"]
                @summary = movie["overview"]
            
                if @movie_titles.include?(@title) == false
                    @movie_titles << @title
                    @movie_posters << @poster
                    @movie_summaries << @summary
                end
            end
        end
    end
    
end