class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.xml
  def index
    conditions = {}
    conditions[:name_like] = "%#{params[:search]}%" unless params[:search].blank?
    @artists = Artist.search(params[:page], :conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end

end
