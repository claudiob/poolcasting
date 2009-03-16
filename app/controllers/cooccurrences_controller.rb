class CooccurrencesController < ApplicationController
  # GET /cooccurrences
  # GET /cooccurrences.xml
  def index
    unless params[:song_id].blank?
      @first_song = Song.find(params[:song_id]) 
      conditions = "song_id = #{@first_song.id}"
    end
    @cooccurrences = Cooccurrence.paginate(:conditions => conditions,
      :joins => "JOIN songs s1 ON s1.id = song_id JOIN songs s2 ON s2.id = next_song_id",
      :page => params[:page], :per_page  => 15)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cooccurrences }
    end
  end

  # GET /cooccurrences/1
  # GET /cooccurrences/1.xml
  def show
    @cooccurrence = Cooccurrence.find(params[:id],
      :joins => "JOIN songs s1 ON s1.id = song_id JOIN songs s2 ON s2.id = next_song_id")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cooccurrence }
    end
  end

end
