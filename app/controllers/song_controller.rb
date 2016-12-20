require 'rack-flash'
class SongController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  use Rack::Flash

  get '/songs/new' do
    erb (:'songs/new')
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb (:'songs/edit')
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb (:'songs/show')
  end

  get '/songs' do
    erb (:'songs/index')
  end

  post '/songs' do
    @song = Song.create(name: params[:name])

      if !params[:artist].empty?
        @artist = Artist.find_or_create_by(name: params[:artist])
        @song.update(artist_id: @artist.id)
      elsif params[:artist].empty?
        @song.update(artist_id: params[:artist_id])
      end
      if !params[:genre].empty?
        @genre = Genre.find_or_create_by(name: params[:genre])
        @song.update(genre_ids: @genre.id)
      elsif params[:genre].empty?
        @song.update(genre_ids: params[:genre_id])
      end
    flash[:message] = "Successfully created song."
    redirect ("songs/#{@song.slug}")
  end

  post '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(name: params[:name])  if !params[:name].empty?
      if !params[:artist].empty?
        @artist = Artist.find_or_create_by(name: params[:artist])
        @song.update(artist_id: @artist.id)
      end
    flash[:message] = "Successfully updated song."
    redirect ("songs/#{@song.slug}")
  end

end
