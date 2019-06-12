class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @current_squad = current_user.squad
    @messages = Message.all
    @message = Message.new
    @squads = Squad.all.reject { |squad| squad == @current_squad }


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(message_params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(message_params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create

    @message = Message.new(message_params[:message])

    respond_to do |format|
      if @message.save
        #format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
        format.html { redirect_to :back }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(message_params[:id])

    respond_to do |format|
      if @message.update_attributes(message_params[:message])
        @format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def deleta


    @message = Message.find(message_params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end

  private

  def message_params
    params.require(:message).permit!
  end
end
