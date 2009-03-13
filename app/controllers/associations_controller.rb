class AssociationsController < ApplicationController
  # GET /associations
  # GET /associations.xml
  def index
    conditions = {}
    unless params[:cooccurrence_id].blank?
      conditions[:cooccurrence_id] = params[:cooccurrence_id] 
    end
    unless params[:song_id].blank?
      conditions['cooccurrences.predecessor_id'] = params[:song_id] 
      conditions['cooccurrences.predecessor_type'] = 'Song'
    end
    unless params[:artist_id].blank?
      conditions['cooccurrences.predecessor_id'] = params[:artist_id]
      conditions['cooccurrences.predecessor_type'] = 'Artist'
    end
    unless params[:parameter_id].blank?
      conditions[:parameter_id] = params[:parameter_id] 
    end
    @associations = Association.search(params[:page], :conditions => conditions,
                      :order => '0.5*song_to_song + 0.3*song_to_artist + 0.2*artist_to_artist DESC',
                      :include => :cooccurrence) # => [:predecessor, :successor]])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @associations }
    end
  end

  # GET /associations/1
  # GET /associations/1.xml
  def show
    @association = Association.find(params[:id], :include => [:cooccurrence, :parameter])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @association }
    end
  end
end
