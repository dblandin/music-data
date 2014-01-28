require 'net/http'
require 'json_tools'

class QueryFetcher
  include JSONTools

  API_KEY = '493b35696b6907219cca0c19c9170fed'

  attr_reader :query, :json_response

  def initialize(query)
    @query = query
  end

  def base_url
    'http://ws.audioscrobbler.com/2.0/'
  end

  def request_params
    { 'method'  => 'artist.search',
      'page'    => '1',
      'artist'  => query,
      'api_key' => API_KEY,
      'format'  => 'json' }
  end

  def url
    "#{base_url}?#{parameterize(request_params)}"
  end

  def fetch
    uri     = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      @json_response = JSON.parse(response.body)
    else
      puts response.message
    end
  end

  def queue_up_requests
    fetch_request_params.each do |worker_params|
      ArtistFetcherWorker.perform_async(worker_params)
    end
  end

  def fetch_request_params
    1.upto(pages).map do |page|
      request_params.merge('page' => page)
    end
  end

  def pages
    (total_results / per_page.to_f).ceil
  end

  def total_results
    json_response.fetch('results').fetch('opensearch:totalResults').to_i
  end

  def per_page
    json_response.fetch('results').fetch('opensearch:itemsPerPage').to_i
  end
end
