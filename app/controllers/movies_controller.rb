class MoviesController < ApplicationController

  def index
    # @movies = Movie.all
    @movies = Movie.all.order(:title)
    @movies = @movies.sort_by { |value| value.title}
    # Rails.logger.debug(@movies.class)
  end

  def new_record?
    @new_record || false
  end

  def show
    id = params[:id] 
    
    begin
      @movie = Movie.find(id) 
    rescue ActiveRecord::RecordNotFound => e
      flash[:warning] = "no movie with the given ID could be found"
      respond_to do |client_wants|
        client_wants.html {  redirect_to movies_path  }
        client_wants.xml  {  render :xml => @movie.to_xml    }
      end
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.create(movies_params)
    Rails.logger.debug("@movie: #{@movie}")
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      respond_to do |client_wants|
        client_wants.html {  redirect_to movie_path(@movie)  }
        client_wants.xml  {  render :xml => @movie.to_xml    }
      end
    else 
      render 'new'
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end
   
  def update
    @movie = Movie.find params[:id]
    if @movie.update(movies_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      respond_to do |client_wants|
        client_wants.html {  redirect_to movie_path(@movie)  }
        client_wants.xml  {  render :xml => @movie.to_xml    }
      end
    else
      render 'edit'
    end

  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    respond_to do |client_wants|
      client_wants.html {  redirect_to movies_path  }
      client_wants.xml  {  render :xml => @movie.to_xml    }
    end
  end

  

  private
    def movies_params
      params.require(:movie).permit(:title, :rating,:description, :release_date)
    end
end
