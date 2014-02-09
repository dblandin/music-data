class ArtistFetcherWorker
  include Sidekiq::Worker

  def perform(query, page)
    Artist.transaction do
      fetcher = ArtistFetcher.new(query)

      fetcher.fetch(page: page)

      artists = ArtistExtractor.new(fetcher.artists).extract!

      artists.each { |artist_params| ArtistBuilder.new(artist_params).create! }
    end
  end
end
