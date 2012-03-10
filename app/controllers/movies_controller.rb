class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   		
	@selected_ratings = []
	@ticked = {}	
	
	@all_ratings = Movie.all_ratings 
	
	if params[:commit] == 'Refresh'
				
		if params[:ratings] != nil
			params[:ratings].each_key do |r| 
				@selected_ratings << r
				@ticked[r] = true
			end
		end	
	else
		@selected_ratings = @all_ratings
		@selected_ratings.each { |r| @ticked[r] = false }
	end
		
	if params[:sort] == 'title' 
		@header_class = 'hilite'
	end
	
	if params[:sort] == 'release_date' 
		@release_date_class = 'hilite'
	end
		
	@movies = Movie.all(:conditions => {'rating' => @selected_ratings}, :order => params[:sort])
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
