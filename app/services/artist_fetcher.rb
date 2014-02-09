require 'net/http'
require 'json_tools'

class ArtistFetcher
  include JSONTools

  attr_reader :query, :page, :api_key, :response

  def initialize(query, page = 1, api_key = '493b35696b6907219cca0c19c9170fed')
    @query   = query
    @page    = page
    @api_key = api_key
  end

  def base_url
    'http://ws.audioscrobbler.com/2.0/'
  end

  def params
    { 'method'  => 'artist.search',
      'page'    => page,
      'artist'  => query,
      'api_key' => api_key,
      'format'  => 'json' }
  end

  def fetch
    uri     = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    $redis.incr("rate-#{api_key}")

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
