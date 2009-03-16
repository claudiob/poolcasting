class AssociationsController < ApplicationController
  # GET /associations
  # GET /associations.xml
  def index
    unless params[:cooccurrence_id].blank?
      conditions = "cooccurrence_id = #{params[:cooccurrence_id]}"
    end
    unless params[:song_id].blank?
      @first_song = Song.find(params[:song_id]) 
      conditions = "cooccurrences.song_id = #{@first_song.id}"
    end
    @associations = Association.paginate(:conditions => conditions,
      :include => :cooccurrence, :page => params[:page], :per_page  => 15,
      :order => "cooccurrences.song_id, degree DESC")


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @associations }
    end
  end

  # GET /associations/1
  # GET /associations/1.xml
  def show
    @association = Association.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @association }
    end
  end

  # GET /associations/new
  # GET /associations/new.xml
  def new
    @association = Association.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @association }
    end
  end

  # GET /associations/1/edit
  def edit
    @association = Association.find(params[:id])
  end

  # POST /associations
  # POST /associations.xml
  def create
    @association = Association.new(params[:association])

    respond_to do |format|
      if @association.save
        flash[:notice] = 'Association was successfully created.'
        format.html { redirect_to(@association) }
        format.xml  { render :xml => @association, :status => :created, :location => @association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /associations/1
  # PUT /associations/1.xml
  def update
    @association = Association.find(params[:id])

    respond_to do |format|
      if @association.update_attributes(params[:association])
        flash[:notice] = 'Association was successfully updated.'
        format.html { redirect_to(@association) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /associations/1
  # DELETE /associations/1.xml
  def destroy
    @association = Association.find(params[:id])
    @association.destroy

    respond_to do |format|
      format.html { redirect_to(associations_url) }
      format.xml  { head :ok }
    end
  end
end
