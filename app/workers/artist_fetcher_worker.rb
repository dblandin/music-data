require 'net/http'
require 'json_tools'

class ArtistFetcherWorker
  API_KEY = '493b35696b6907219cca0c19c9170fed'

  include Sidekiq::Worker, JSONTools

  attr_reader :request_params

  def base_url
    'http://ws.audioscrobbler.com/2.0/'
  end

  def url
    "#{base_url}?#{parameterize(request_params)}"
  end

  def perform(request_params)
    @request_params = request_params.merge('api_key' => API_KEY)

    uri     = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      Artist.transaction do
        parsed_response = JSON.parse(response.body)

        artists = ArtistExtractor.new(parsed_response).extract!

        artists.each do |artist_params|
          ArtistBuilder.new(artist_params).create!
        end
      end
    else
      puts response.message
    end
  end
end
