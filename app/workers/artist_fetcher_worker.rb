class ArtistFetcherWorker
  API_KEYS = %w(
    493b35696b6907219cca0c19c9170fed
    af9dcd7846bef3fc7980542409f79e69
    d64eda6fa585771c598d892425a8cdf3
  )

  MINUTE_RATE_LIMIT = 180

  attr_reader :page

  include Sidekiq::Worker

  def perform(query, page, force = false)
    @page = page

    return ArtistFetcherWorker.perform_in(1.minute, query, page, force) if rate_limit_reached?

    unless force || already_fetched?
      Artist.transaction do
        fetcher = ArtistFetcher.new(query, page, available_keys.first)

        artists = ArtistExtractor.new(fetcher.artists).extract!

        artists.each { |artist_params| ArtistBuilder.new(artist_params).create! }

        Collection.create(page: page, type: 'ArtistCollection')
      end
    end
  end

  def already_fetched?
    Collection.exists?(page: page, type: 'ArtistCollection')
  end

  def available_keys
    @available_keys ||= API_KEYS.select { |key| $redis.get("rate-#{key}").to_i < MINUTE_RATE_LIMIT }
  end

  def rate_limit_reached?
    available_keys.empty?
  end
end
