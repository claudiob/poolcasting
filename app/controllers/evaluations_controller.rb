class EvaluationsController < ApplicationController
  # GET /evaluations
  # GET /evaluations.xml
  def index
    @evaluations = Evaluation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evaluations }
    end
  end

  # GET /evaluations/1
  # GET /evaluations/1.xml
  def show
    @evaluation = Evaluation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evaluation }
    end
  end

  # GET /evaluations/new
  # GET /evaluations/new.xml
  def new
    unless params[:association_id].blank?
      @association = Association.find(params[:association_id])
    else  # either create a fake one or pick one at random
      @association = Association.create_or_random # Should be able to pass song
    end  
    @evaluation = Evaluation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evaluation }
    end
  end

  # POST /evaluations
  # POST /evaluations.xml
  def create
    # Here I would add participant = guest if no participant is indicated
    case params[:submit]
      when "Good"
        params[:evaluation][:degree] = 1.0
      when "Bad" 
        params[:evaluation][:degree] = 0.0
    end
    @evaluation = Evaluation.new(params[:evaluation])

    respond_to do |format|
      if @evaluation.save
        flash[:notice] = 'Evaluation was successfully created.'
        format.html { redirect_to(@evaluation) }
        format.xml  { render :xml => @evaluation, :status => :created, :location => @evaluation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evaluation.errors, :status => :unprocessable_entity }
      end
    end
  end

end
