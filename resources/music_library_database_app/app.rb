# file: app.rb
require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/album'
require_relative 'lib/artist'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:all_albums)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    album = album_repo.find(params[:id])
    @title = album.title
    @release_year = album.release_year
    artist_repo = ArtistRepository.new
    artist = artist_repo.find(album.artist_id)
    @artist_name = artist.name
    return erb(:album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:all_artists)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    artist = repo.find(params[:id])
    @name = artist.name
    @genre = artist.genre
    return erb(:artist)
  end

  post '/albums' do
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    album = Album.new
    album.title = title
    album.release_year = release_year
    album.artist_id = artist_id

    repo = AlbumRepository.new
    repo.create(album)
  end

  post '/artists' do
    name = params[:name]
    genre = params[:genre]

    artist = Artist.new
    artist.name = name
    artist.genre = genre

    repo = ArtistRepository.new
    repo.create(artist)
  end
end
