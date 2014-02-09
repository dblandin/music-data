class ArtistExtractor
  attr_reader :artists_json

  def initialize(artists_json)
    @artists_json = artists_json
  end

  def extract!
    artists_json.map { |artist_params| ArtistParamsExtractor.new(artist_params).extract! }
  end

  class ArtistParamsExtractor
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def extract!
      { mbid: params['mbid'],
        name: params['name'] }
    end
  end
end
