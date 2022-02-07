class ReviewsController < ApplicationController
  before_action :lookup_movie 
  before_action :ensure_user ,only: [:edit, :update]
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

  def edit
    @review = Review.find params[:id]
  end
   
  def update
    @review = Review.find params[:id]
    @movie = Movie.find(params[:movie_id])
    if @review.update(reviews_params)
      flash[:notice] = "#{@review.id} was successfully updated."
      Rails.logger.debug("update update update ")
      respond_to do |client_wants|
        client_wants.html {  redirect_to movie_reviews_path(@movie)  }
        client_wants.xml  {  render :xml => @review.to_xml    }
      end
    else
      render 'edit'
    end

  end

  def ensure_user 
    @review = Review.find params[:id]
    @movie = Movie.find(params[:movie_id])
    unless @review.moviegoer_id == @current_user.id
      flash[:warning] = "You cannot edit or update other users."
      redirect_to movie_reviews_path(@movie)
    end
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
