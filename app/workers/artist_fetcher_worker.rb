class ArtistFetcherWorker
  attr_reader :page

  include Sidekiq::Worker

  def perform(query, page, force = false)
    @page = page

    unless force || already_fetched?
      Artist.transaction do
        fetcher = ArtistFetcher.new(query, page)

        artists = ArtistExtractor.new(fetcher.artists).extract!

        artists.each { |artist_params| ArtistBuilder.new(artist_params).create! }

        Collection.create(page: page, type: 'ArtistCollection')
      end
    end
  end

  def already_fetched?
    Collection.exists?(page: page, type: 'ArtistCollection')
  end
end
