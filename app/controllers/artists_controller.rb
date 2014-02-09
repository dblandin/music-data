class ArtistsController < ApplicationController
  respond_to :json

  def index
    respond_with QueryFetcher.new(artist_params[:name], artist_params[:page]).fetch
  end

  def artist_params
    params.permit!
  end
end
