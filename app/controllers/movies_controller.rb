class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
 	
	@selected_ratings = []
	@ticked = {}
	@sort = ''
		
	@all_ratings = Movie.all_ratings 
	
	redirect_needed = false
	
	if session[:current] == nil
		session[:current] = true
		@selected_ratings = @all_ratings
		@selected_ratings.each { |r| @ticked[r] = true }
	end
	
	if params[:ratings] == nil
		if session[:selected] != nil
			params[:ratings] = {}
			session[:selected].each { |r| params[:ratings][r] = '1'} 
			redirect_needed = true
		end
	end
	
	if params[:sort] == nil
		if session[:sort] != nil
			params[:sort] = session[:sort]
			redirect_needed = true
		end
	end	
		
	if redirect_needed 
		p "call redirect with" 
		p params
		redirect_to movies_path(params)
	end
		
	if params[:ratings] != nil
		session.delete(:selected)
		params[:ratings].each_key do |r| 
			@selected_ratings << r
			@ticked[r] = true
		end
	end

	@sort = params[:sort]
	if @sort == 'title' 
		@header_class = 'hilite'
	elsif @sort == 'release_date' 
		@release_date_class = 'hilite'
	end
	
	# preserve users selection and sort for same session
	session[:selected] = @selected_ratings
	session[:sort] = @sort
	
	@movies = Movie.all(:conditions => {'rating' => @selected_ratings}, :order => @sort)

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
