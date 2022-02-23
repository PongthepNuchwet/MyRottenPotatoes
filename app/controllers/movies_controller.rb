require 'singleton'

class MoviesParams
  include Singleton

  def Require1(params)
    params.require(:movie).permit(:title, :rating,:description, :release_date)
  end

end

class For_kids
  def movies()
    return @movies = Movie.for_kids
  end
end

class Recently_reviewed
  def initialize(params)
    @@params = params
  end
  def movies()
    return @movies = Movie.recently_reviewed(@@params[:query][:day])
  end
end


class AdapterFilter

  def initialize(params)
    @@params = params
  end

  def filters()
    if @@params[:query][:filter] == 'for_kids' 
      for_kids = For_kids.new
      return for_kids.movies()
    elsif @@params[:query][:filter] == 'recently_reviewed' 
      recently_reviewed = Recently_reviewed.new(@@params)
      return recently_reviewed.movies()
    else
      return Movie.all.order(:title)
    end
  end
end

class NilFilter
  def movies()
    @movies = Movie.all.order(:title)
    return @movies = @movies.sort_by { |value| value.title}
  end
end

class MoviesController < ApplicationController

  def filters
    render :template => "movies/filters"
  end
  
  def for_kids
    @movies = Movie.for_kids
    render :template => "movies/filters"
  end

  def recently_reviewed
    @movies = Movie.recently_reviewed(params[:query][:day])
    render :template => "movies/filters"
  end

  def index
    if params[:query] 
      adapterFilter = AdapterFilter.new(params)
      @movies = adapterFilter.filters()
    else 
      nilFilter = NilFilter.new
      @movies = nilFilter.movies()
    end
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
    @movie = Movie.create(MoviesParams.instance.Require1(params))
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
    if @movie.update(MoviesParams.instance.Require1())
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

  

  # private
  #   def movies_params
  #     params.require(:movie).permit(:title, :rating,:description, :release_date)
  #   end
end
