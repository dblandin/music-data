require 'spec_helper'

describe 'ArtistExtractor' do
  describe '#extract!' do
    it 'extracts all artists from a response' do
      artists = ArtistExtractor.new(artists_json).extract!

      expected_output = {
        mbid: 'bfcc6d75-a6a5-4bc6-8282-47aec8531818',
        name: 'Cher'
      }

      expect(artists.first).to eq(expected_output)
      expect(artists.count).to eq(30)
    end
  end

  def artists_json
    dummy_response['results']['artistmatches']['artist']
  end

  def dummy_response
    Oj.load(File.read(File.expand_path('../../fixtures/artist_result.json', __FILE__)))
  end
end
