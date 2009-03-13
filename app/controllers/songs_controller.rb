class SongsController < ApplicationController
  openstrands
  # GET /songs
  # GET /songs.xml
  def index
    conditions = {}
    conditions[:name_like] = "%#{params[:search]}%" unless params[:search].blank?
    conditions[:artist_id] = params[:artist_id] unless params[:artist_id].blank?
    conditions[:genre_id] = params[:genre_id] unless params[:genre_id].blank?
    @songs = Song.search(params[:page], :conditions => conditions, 
                                        :include => [:artist, :genre])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
#    if params[:cooccurrence_id]
#      @song = Cooccurrence.find(params[:cooccurrence_id]).song
#    else
    @song = Song.find(params[:id], :include => [:artist, :genre])
    @title = openstrands_lookup_track(params[:id])
    unless @title[:wma_clip_uri].blank?
      @player = '<object id="MediaPlayer" height=46 classid="CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95" standby="Loading Windows Media Player components..." type="application/x-oleobject" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,4,7,1112">
      <param name="filename" value="http://www.mystrands.com/clip/3852/WMA/mn4rj8wja7i7net5g86kwqs">
      <param name="Showcontrols" value="True">
      <param name="autoStart" value="False">
      <embed type="application/x-mplayer2" src="http://www.mystrands.com/clip/3852/WMA/mn4rj8wja7i7net5g86kwqs" name="MediaPlayer"></embed>
      </object>'
    end
    logger.error @player

#    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

end


