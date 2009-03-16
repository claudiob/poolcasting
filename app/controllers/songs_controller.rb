class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    @songs = Song.paginate(:page => params[:page], :per_page  => 15,
      :joins => "JOIN cooccurrences ON song_id = songs.id",
      :include => :artist)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id], :include => :artist)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @songs }
      format.wma  { send_data('<ASX VERSION="3.0">
        <ENTRY>
          <REF HREF="' + @song.identifications[0].identifier[:wma_clip_uri] + '" />
        </ENTRY>
      </ASX>', :filename => "#{@song.id}.wax", :type => "audio/x-ms-wax") }
      format.rm  { send_data(@song.identifications[0].identifier[:rm_clip_uri], 
        :filename => "#{@song.id}.rm", :type => "application/vnd.rn-realmedia") }
    end
  end

end


