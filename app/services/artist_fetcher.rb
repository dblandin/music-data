require 'net/http'
require 'json_tools'

class ArtistFetcher
  include JSONTools

  API_KEY = '493b35696b6907219cca0c19c9170fed'

  attr_reader :query, :response, :page

  def initialize(query, page = 1)
    @query = query
    @page  = page
  end

  def base_url
    'http://ws.audioscrobbler.com/2.0/'
  end

  def params
    { 'method'  => 'artist.search',
      'page'    => page,
      'artist'  => query,
      'api_key' => API_KEY,
      'format'  => 'json' }
  end

  def fetch
    uri     = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def response
    @response ||= fetch
  end

  def artists
    response.with_indifferent_access.fetch('results').fetch('artistmatches').fetch('artist')
  end

  def url
    "#{base_url}?#{parameterize(params)}"
  end

  def pages
    (results / per_page.to_f).ceil
  end

  def per_page
    response.fetch('results').fetch('opensearch:itemsPerPage').to_i
  end

  def results
    response.fetch('results').fetch('opensearch:totalResults').to_i
  end
end
