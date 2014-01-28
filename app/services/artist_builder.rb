class ArtistBuilder
  attr_reader :artist_params

  def initialize(artist_params)
    @artist_params = artist_params
  end

  def create!
    artist.save!
  end

  def artist
    find_artist || build_artist
  end

  def find_artist
    Artist.where(mbid: artist_params[:mbid]).first
  end

  def build_artist
    Artist.new(artist_params)
  end
end
