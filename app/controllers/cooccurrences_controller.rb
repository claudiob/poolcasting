class CooccurrencesController < ApplicationController
  # GET /cooccurrences
  # GET /cooccurrences.xml
  def index
    conditions = {}
    unless params[:song_id].blank?
      conditions[:predecessor_id] = params[:song_id]
      conditions[:predecessor_type] = 'Song'
    end
    unless params[:artist_id].blank?
      conditions[:predecessor_id] = params[:artist_id]
      conditions[:predecessor_type] = 'Artist'
    end
    @cooccurrences = Cooccurrence.search(params[:page], 
      :conditions => conditions) #, :include => [:predecessor, :successor] )
      # Add indexes in order to do :order => 'd1 DESC, d2 DESC, d3 DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cooccurrences }
    end
  end

  # GET /cooccurrences/1
  # GET /cooccurrences/1.xml
  def show
    @cooccurrence = Cooccurrence.by_song.find(params[:id], :include => [:predecessor, :successor])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cooccurrence }
    end
  end

end
