require 'json_tools'

class ArtistSearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def json_response
    @json_response ||= ArtistFetcher.new(query).response
  end

  def pages
    (results / per_page.to_f).ceil
  end

  def per_page
    json_response.fetch('results').fetch('opensearch:itemsPerPage').to_i
  end

  def results
    json_response.fetch('results').fetch('opensearch:totalResults').to_i
  end
end
