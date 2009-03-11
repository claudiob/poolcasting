class GenresController < ApplicationController
  # GET /genres
  # GET /genres.xml
  def index
    conditions = {}
    conditions[:name_like] = "%#{params[:search]}%" unless params[:search].blank?
    @genres = Genre.search(params[:page], :conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genres }
    end
  end

  # GET /genres/1
  # GET /genres/1.xml
  def show
    @genre = Genre.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @genre }
    end
  end

end
