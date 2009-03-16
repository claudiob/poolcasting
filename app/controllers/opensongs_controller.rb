class OpensongsController < ApplicationController
  # GET /opensongs
  # GET /opensongs.xml
  def index
    @opensongs = Opensong.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @opensongs }
    end
  end

  # GET /opensongs/1
  # GET /opensongs/1.xml
  def show
    @opensong = Opensong.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @opensong }
    end
  end

  # GET /opensongs/new
  # GET /opensongs/new.xml
  def new
    @opensong = Opensong.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @opensong }
    end
  end

  # GET /opensongs/1/edit
  def edit
    @opensong = Opensong.find(params[:id])
  end

  # POST /opensongs
  # POST /opensongs.xml
  def create
    @opensong = Opensong.new(params[:opensong])

    respond_to do |format|
      if @opensong.save
        flash[:notice] = 'Opensong was successfully created.'
        format.html { redirect_to(@opensong) }
        format.xml  { render :xml => @opensong, :status => :created, :location => @opensong }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @opensong.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /opensongs/1
  # PUT /opensongs/1.xml
  def update
    @opensong = Opensong.find(params[:id])

    respond_to do |format|
      if @opensong.update_attributes(params[:opensong])
        flash[:notice] = 'Opensong was successfully updated.'
        format.html { redirect_to(@opensong) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @opensong.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /opensongs/1
  # DELETE /opensongs/1.xml
  def destroy
    @opensong = Opensong.find(params[:id])
    @opensong.destroy

    respond_to do |format|
      format.html { redirect_to(opensongs_url) }
      format.xml  { head :ok }
    end
  end
end
