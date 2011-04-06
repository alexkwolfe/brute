class CallsController < ApplicationController
  respond_to :xml

#  def in_progress
#    render :status => :ok
#  end
#
#  def finished
#    render :xml => Twilio::Verb.hangup
#  end

  def connection_to_target_failed
    if params[:CallStatus] == 'busy' || params[:CallStatus] == 'no-answer'
      @call = Call.find(params[:id])
      @call.connect_to_target
    end
    render :xml => Twilio::Verb.hangup
  end

  def connected_to_target
    @call = Call.find(params[:id])
    verb = Twilio::Verb.new { |v|
      v.dial {
        v.conference "call_#{@call.id}"
      }
    }
    render :xml => verb.response
  end

  def connected_to_caller
    @call = Call.find(params[:id])
    verb = Twilio::Verb.new { |v|
      v.say "Please wait while I connect to #{@call.target_number.scan(/./).join(' ')}."
      v.dial {
        v.conference "call_#{@call.id}"
      }

    }
    Thread.new {
      @call.connect_to_target
      @call.connect_to_target
      @call.connect_to_target
      @call.connect_to_target
      @call.connect_to_target
    }
    render :xml => verb.response
  end


#  # GET /calls
#  # GET /calls.xml
#  def index
#    @calls = Call.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @calls }
#    end
#  end
#
#  # GET /calls/1
#  # GET /calls/1.xml
#  def show
#    @call = Call.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @call }
#    end
#  end
#
#  # GET /calls/new
#  # GET /calls/new.xml
#  def new
#    @call = Call.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @call }
#    end
#  end
#
#  # GET /calls/1/edit
#  def edit
#    @call = Call.find(params[:id])
#  end
#
  # POST /calls
  # POST /calls.xml
  def create
    @call = Call.new(params[:call])
    if @call.save
      render :json => @call, :status => :created, :location => @call
    else
      render :json => @call.errors, :status => :unprocessable_entity
    end
  end
#
#  # PUT /calls/1
#  # PUT /calls/1.xml
#  def update
#    @call = Call.find(params[:id])
#
#    respond_to do |format|
#      if @call.update_attributes(params[:call])
#        format.html { redirect_to(@call, :notice => 'Call was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @call.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /calls/1
#  # DELETE /calls/1.xml
#  def destroy
#    @call = Call.find(params[:id])
#    @call.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(calls_url) }
#      format.xml  { head :ok }
#    end
#  end
end
