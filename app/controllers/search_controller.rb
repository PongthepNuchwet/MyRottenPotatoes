class SearchController < ApplicationController
  def index
    @query = params[:query][:value]
    redirect_to search_keyword_path(@query)
  end

  def query 
    @query = params[:query]
    @movies = Movie.find_in_tmdb(@query)
  end
end
