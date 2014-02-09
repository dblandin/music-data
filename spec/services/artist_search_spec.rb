require 'spec_helper'

vcr_options = { cassette_name: 'artists', record: :new_episodes }
describe ArtistSearch, vcr: vcr_options do
  describe 'pages' do
    it 'returns the number of pages for a search query' do
      search = ArtistSearch.new('Cher')

      expect(search.pages).to eq(52)
      expect(search.results).to eq(1558)
    end
  end
end
