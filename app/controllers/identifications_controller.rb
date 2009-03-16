class IdentificationsController < ApplicationController
  # GET /identifications
  # GET /identifications.xml
  def index
    @identifications = Identification.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @identifications }
    end
  end

  # GET /identifications/1
  # GET /identifications/1.xml
  def show
    @identification = Identification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @identification }
    end
  end

  # GET /identifications/new
  # GET /identifications/new.xml
  def new
    @identification = Identification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @identification }
    end
  end

  # GET /identifications/1/edit
  def edit
    @identification = Identification.find(params[:id])
  end

  # POST /identifications
  # POST /identifications.xml
  def create
    @identification = Identification.new(params[:identification])

    respond_to do |format|
      if @identification.save
        flash[:notice] = 'Identification was successfully created.'
        format.html { redirect_to(@identification) }
        format.xml  { render :xml => @identification, :status => :created, :location => @identification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @identification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /identifications/1
  # PUT /identifications/1.xml
  def update
    @identification = Identification.find(params[:id])

    respond_to do |format|
      if @identification.update_attributes(params[:identification])
        flash[:notice] = 'Identification was successfully updated.'
        format.html { redirect_to(@identification) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @identification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /identifications/1
  # DELETE /identifications/1.xml
  def destroy
    @identification = Identification.find(params[:id])
    @identification.destroy

    respond_to do |format|
      format.html { redirect_to(identifications_url) }
      format.xml  { head :ok }
    end
  end
end
