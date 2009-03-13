class ParametersController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]

  # GET /parameters
  # GET /parameters.xml
  def index
    @parameters = Parameter.find(:all)

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
    @parameter = Parameter.active

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @parameter }
    end
  end

  # PUT /parameters/1
  # PUT /parameters/1.xml
  def update
    @parameter = Parameter.new(params[:parameter])
    respond_to do |format|
      if @parameter.save
        # Here I should recalculate some associations, depending on the parameters changed
        flash[:notice] = 'Parameters were successfully updated.'
        format.html { redirect_to(@parameter) }
        format.xml  { render :xml => @parameter, :status => :created, :location => @parameter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "foo" && password == "bar"
    end
  end  
end
