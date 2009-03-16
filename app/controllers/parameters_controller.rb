class ParametersController < ApplicationController
  # GET /parameters
  # GET /parameters.xml
  def index
    @parameters = Parameter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parameters }
    end
  end

  # GET /parameters/1
  # GET /parameters/1.xml
  def show
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @parameter }
    end
  end

  # GET /parameters/new
  # GET /parameters/new.xml
  def new
    @parameter = Parameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @parameter }
    end
  end

  # POST /parameters
  # POST /parameters.xml
  def create
    @parameter = Parameter.new(params[:parameter])

    respond_to do |format|
      if @parameter.save
        flash[:notice] = 'Parameter was successfully created.'
        format.html { redirect_to(@parameter) }
        format.xml  { render :xml => @parameter, :status => :created, :location => @parameter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

end
