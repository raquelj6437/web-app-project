require 'paralleldots'
require 'dotenv/load'
require 'pp'
require 'json'
require 'open-uri'

set_api_key(ENV["PARALLEL_API"]) # authentication for Parallel Dots API

$moods = {
    "happy" => ["Comedy", "Adventure", "Action"],
    "sad" => ["Drama", "Romantic Comedy"],
    "angry" => ["Thriller", "Mystery", "Horror"],
    "excited" => ["Animation", "Kids", "Comedy"],
    "fear" => ["Horror", "Comedy"],
    "bored" => ["Comedy", "Action", "Thriller"]
}

def get_mood(mood)
    @user_mood=emotion(mood) # the mood the user puts in is analyzed by the api - returns a hash
    @user_mood = @user_mood["emotion"]["emotion"] # goes into the hash and finds the associated emotion, assigns it to @user_mood
end


def genres(moods_hash)
    moods_hash.each do |mood,moods| # iterates through the moods hash
        if mood == @user_mood.downcase # if the mood in the moods hash is equal to the mood in @user_mood
            @genre_list = moods # sets the variable equal to the value in the moods hash, which is an array
        end
    end
end

# class of each movie
class Movie
    attr_reader :title, :poster, :summary, :movie_titles, :movie_posters, :movie_summaries, :movie_ratings, :movie_release_dates, :movie_languages, :movie_ids
 
    def initialize
        # each movie list
        @movie_titles = []
        @movie_posters = []
        @movie_summaries = []
        @movie_ratings = []
        @movie_release_dates = []
        @movie_languages = []
        @movie_ids = []
    end
    
    def get_genre_id(genre)
        @id_arr = []
        genres = JSON.parse(open('https://api.themoviedb.org/3/genre/movie/list?api_key=' + ENV['MOVIE_API']){ |x| x.read }) # based on the genre, it finds the genre id
        genres['genres'].each do |i| 
            genre.each do |x|
                if x == i['name']
                    @id_arr.push(i['id'].to_s)
                end
            end
        end
        return @id_arr
    end

    # gets a list of movies based on the genre
    def get_movies_by_genre(genre)
        @movie_arr = []
        genre.each do |id|
            movies = JSON.parse(open("https://api.themoviedb.org/3/discover/movie?with_genres="+ id +"&api_key=" + ENV['MOVIE_API']){ |x| x.read })
            @movie_arr.push(movies["results"])
        end
    end
    
    # gets id of the movie trailer
    def get_trailer(id)
        movie = JSON.parse(open("https://api.themoviedb.org/3/movie/"+ id +"?api_key= " + ENV['MOVIE_API'] + "&append_to_response=videos"){ |x| x.read })
        link = movie['videos']['result'][0]['key']
        # movie_trailer_link
        puts link
    end
    
    # get the trailer of movie
    def get_trailer(id)
        id = id.to_s
        movie = JSON.parse(open("https://api.themoviedb.org/3/movie/"+ id +"?api_key=" + ENV['MOVIE_API'] + "&append_to_response=videos"){ |x| x.read })
        if movie['videos']['results'][0] == nil
            return
        else
            link = movie['videos']['results'][0]['key']
            @movie_trailer_link = "https://www.youtube.com/watch?v=" + link
            return @movie_trailer_link
        end
    end
    
    def get_info(genre_arr)
        if @movie_titles.length <= 3 
            @movie_arr[0].shuffle!
            for movie in @movie_arr[0]
                @title = movie["title"]
                @poster = movie["poster_path"]
                @summary = movie["overview"]
                @rating = movie["vote_average"]
                @release_date = movie["release_date"]
                @language = movie["original_language"]
                @id = movie["id"]
            
                if @movie_titles.include?(@title) == false
                    @movie_titles << @title
                    @movie_posters << @poster
                    @movie_summaries << @summary
                    @movie_ratings << @rating
                    @movie_release_dates << @release_date
                    @movie_languages << @language
                    @movie_ids << @id
                end
            end
        end
    end
end