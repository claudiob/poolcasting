class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    conditions = {}
    conditions[:name_like] = "%#{params[:search]}%" unless params[:search].blank?
    conditions[:artist_id] = params[:artist_id] unless params[:artist_id].blank?
    conditions[:genre_id] = params[:genre_id] unless params[:genre_id].blank?
    @songs = Song.search(params[:page], :conditions => conditions, 
                                        :include => [:artist, :genre],
                                        :order => 'popularity DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id], :include => [:artist, :genre])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

end
