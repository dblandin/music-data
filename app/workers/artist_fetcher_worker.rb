class ArtistFetcherWorker
  MINUTE_RATE_LIMIT = 180

  attr_reader :page, :query

  include Sidekiq::Worker

  def perform(query, page, force = false)
    @query = query
    @page  = page

    return ArtistFetcherWorker.perform_in(1.minute, query, page, force) if rate_limit_reached?

    unless force || already_fetched?
      Artist.transaction do
        fetcher = ArtistFetcher.new(query, page, available_keys.first)

        artists = ArtistExtractor.new(fetcher.artists).extract!

        artists.each { |artist_params| ArtistBuilder.new(artist_params).create! }

        ArtistCollection.create(query: query, page: page)
      end
    end
  end

  def already_fetched?
    ArtistCollection.exists?(query: query, page: page)
  end

  def rate_limit_reached?
    available_keys.empty?
  end

  def available_keys
    @available_keys ||= api_keys.select { |key| $redis.get("rate-#{key}").to_i < MINUTE_RATE_LIMIT }
  end

  def api_keys
    @api_keys ||= $redis.get('api_keys').split(',')
  end
end
