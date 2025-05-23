class MoviesController < ApplicationController
  def new
    @movie = Movie.new
  end

  def index
    matching_movies = Movie.all

    @movies = matching_movies.order({ created_at: :desc })

    respond_to do |format|
      format.json do
        render json: @movies
      end

      format.html do
      end
    end
  end

  def show
    @movie = Movie.find(params.fetch(:id))
  end

  def create
    movie_attributes = params.require(:movie).permit(:title, :description)
    @movie = Movie.new(movie_attributes)
    # @movie.title = params.fetch(:movie).fetch(:title)
    # @movie.description = params.fetch(:movie).fetch(:description)

    if @movie.valid?
      @movie.save
      redirect_to movies_url, notice:"Movie was successfully created."
    else
      render "movies/new"
    end
  end

  def edit
    the_id = params.fetch(:id)

    matching_movies = Movie.where(id: the_id)

    @movie = matching_movies.first
  end

  def update
    id = params.fetch(:id)
    movie = Movie.where(id: id).first

    movie.title = params.fetch("query_title")
    movie.description = params.fetch("query_description")

    if movie.valid?
      movie.save
      redirect_to movies_url(movie.id), notice: "Movie updated successfully."
    else
      redirect_to movies_url(movie.id), alert: "Movie failed to update successfully."
    end
  end

  def destroy
    id = params.fetch(:id)
    movie = Movie.where(id: id).first

    movie.destroy

    redirect_to movies_url, notice: "Movie deleted successfully."
  end
end
