class ReviewsController < ApplicationController
  before_action :lookup_movie 
  def index
    @movie = Movie.find(params[:movie_id])
    @reviews ||= @movie.reviews
  end

  def create
    @movie = Movie.find(params[:movie_id])
    Rails.logger.debug("@current_user.uid #{@current_user.id}")
    @moviegoer = Moviegoer.find(@current_user.id)
    
    @review = @movie.reviews.build(reviews_params)
    @review.movie = @movie
    @review.moviegoer = @moviegoer

    if @review.save
      flash[:notice] = "Review successfully created."
      redirect_to(movie_reviews_path(@movie))
    else
      flash[:warning] = "ERROR"
      render :action => 'new'
    end
  end

  def new 
    @movie = Movie.find(params[:movie_id])
    @review ||= @movie.reviews.new
    @review = @review || @movie.reviews.new
  end

  def lookup_movie 

    unless (@movie = Movie.find_by_id(params[:movie_id]))
      flash[:warning] = "movie_id not in params"
      redirect_to root_path
    end

    unless @current_user
      flash[:warning] = 'You must be logged in to create a review.'
      redirect_to root_path
    end

  end

  private
    def reviews_params
      params.require(:review).permit(:potatoes, :comments)
    end


end
