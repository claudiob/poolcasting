class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.xml
  def index
    @artists = Artist.all
    @artists = Artist.paginate(:page => params[:page], :per_page  => 15)

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
