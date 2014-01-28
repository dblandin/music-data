class ArtistExtractor
  attr_reader :params

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def extract!
    params.fetch(:results).fetch(:artistmatches).fetch(:artist).map { |artist_params| ArtistParamsExtractor.new(artist_params).extract! }
  end

  class ArtistParamsExtractor
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def extract!
      { mbid:        params.fetch(:mbid),
        name:        params.fetch(:name) }
    end
  end
end
