class Reviews_params
    
end

class ReviewsController < ApplicationController
  before_action :lookup_movie 
  before_action :ensure_user ,only: [:edit, :update]

  

  def index
    @movie = Movie.find(params[:movie_id])
    @potatoes = image_potatoes(@movie.reviews.average(:potatoes))
  end

  def image_potatoes(number)
    potatoes = Array.new
    if number != nil 
      while number > 0 
        if number >= 1 
            potatoes.push("Potatoe.png")
            number = number - 1
        else
          if number >= 0.75 ; potatoes.push("Potatoe1-4.png")
          elsif number >= 0.5 ; potatoes.push("Potatoe1-3.png")
          elsif number > 0.25 ; potatoes.push("Potatoe1-2.png")
          elsif number > 0 ; potatoes.push("Potatoe1-1.png")
          end
          number = 0
        end
      end
    end
    return potatoes
  end

  def create
    @movie = Movie.find(params[:movie_id])
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
