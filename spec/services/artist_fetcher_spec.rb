require 'spec_helper'

vcr_options = { cassette_name: 'artists', record: :new_episodes }
describe ArtistFetcher, vcr: vcr_options do
  describe 'pages' do
    it 'returns the number of pages for a search query' do
      fetcher = ArtistFetcher.new('Cher')

      expect(fetcher.artists.count).to eq(30)
    end
  end
end
