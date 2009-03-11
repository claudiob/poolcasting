class CooccurrencesController < ApplicationController
  # GET /cooccurrences
  # GET /cooccurrences.xml
  def index
    conditions = {}
    conditions[:song_id] = params[:song_id] unless params[:song_id].blank?
    conditions[:next_song_id] = params[:next_song_id] unless params[:next_song_id].blank?
    @cooccurrences = Cooccurrence.search(params[:page], 
      :conditions => conditions, :include => [{:song => :artist}, {:next_song => :artist}], 
      :order => 'd1 DESC, d2 DESC, d3 DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cooccurrences }
    end
  end

  # GET /cooccurrences/1
  # GET /cooccurrences/1.xml
  def show
    @cooccurrence = Cooccurrence.find(params[:id], :include => [{:song => :artist}, {:next_song => :artist}])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cooccurrence }
    end
  end

end
