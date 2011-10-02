class ListingsController < ApplicationController
  # GET /listings
  # GET /listings.xml
  def index
    @listings = Listing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @listings }
    end
  end

  # Receives incoming text messages from Tropo and handles them
  def receive
    params[:incoming_number] = $1 if params[:incoming_number]=~/^1(\d{10})$/
    params[:origin_number] = $1 if params[:origin_number]=~/^1(\d{10})$/
    
    # id will send you back the details for the listing id provided
    # respond will send a message to the Offeror from the Offeree for the listing id and username provided
    # The message states that the user is interested in the offer and to please contact them at their phone number
    # listnow will conduct a search (kick off the cron job) right then
    commands = [["id"],["respond"],["listnow"],["help"]]
    commands.each do |c|
      pattern = c.first
      function_name = "handle_#{c.last}".to_sym
      if match = params[:message].match(/^#?#{pattern}:?(.*)/i)
        self.send(function_name,match.to_a.last.strip, params[:origin_number])
        #return a 202 to tropo
        render :text=>"sent", :status=>202
        return
      end
    end
    if m=params[:message].match(/^#\w*/)
      message "Sorry, unrecognized command '#{m[0]}'. Text #help for valid commands",params[:origin_number]
      render :text=>"sent", :status=>202
      return
    end

  end
  
  def handle_help(message,number)
    message "Available commands: #id, #respond, #listnow, #help", number
  end
  
  def handle_id(msg, number)
    listingid = msg
    @listing = Listing.find(listingid)
    message "Listing ID#" + listingid + ", Title: " + @listing.title + ", Group: " + @listing.group_name + " , Neighborhood: " + @listing.neighborhood, number
  end
  
  def handle_respond(msg, number)
    listingid = msg
    @listing = Listing.find(listingid)
    agent = Mechanize.new
    agent.get("http://my.freecycle.org/login")
    # The first form is the login form
    form = agent.page.forms.first
    form.username = ENV['FCUSER']
    form.pass = ENV['FEX']
    form.submit
    # now get the detailed listing page
    agent.get("http://groups.freecycle.org/" + @listing.group_name + "/posts/" + @listing.number)
    trs = agent.page.search("tr")
    # keep track of the offeror so we can tell the user who it was
    offeror = trs[2].css("td")[0].css("text()")[0].text
    #offeror = Freecycle::respondtoofferFC(@listing.group_name, listingid, number)
    # TODO: copy in submit code here for the offer response, create a real freecycle page, and TEST
    outmessage = "At your request, a message on Freecycle "+@listing.group_name+", has been sent to " + offeror + " about Post ID "+@listing.number+"."
    message outmessage, number
  end
  
  def handle_listnow(message, number)
    searchid = message
  end

  def message(msg,number)
    #puts "sending '#{msg}' to #{number}"
    $outbound_flocky.message ENV['APP_NUMBER'], msg, number
  end

  # GET /listings/1
  # GET /listings/1.xml
  def show
    @listing = Listing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @listing }
    end
  end

  # GET /listings/new
  # GET /listings/new.xml
  def new
    @listing = Listing.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @listing }
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = Listing.find(params[:id])
  end

  # POST /listings
  # POST /listings.xml
  def create
    @listing = Listing.new(params[:listing])

    respond_to do |format|
      if @listing.save
        format.html { redirect_to(@listing, :notice => 'Listing was successfully created.') }
        format.xml  { render :xml => @listing, :status => :created, :location => @listing }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /listings/1
  # PUT /listings/1.xml
  def update
    @listing = Listing.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to(@listing, :notice => 'Listing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @listing.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /listings/getlisting?number=&group_name=
  def getlisting
    # @listing will be a hash
    @listing = Listing.new({"number"=>params[:number], "group_name"=>params[:group_name]}).detail_listing
    @groupname = params[:group_name]
    respond_to do |format|
      format.html # getlisting.html.erb
      format.xml  { render :xml => @listing }
    end
  end
  
  # DELETE /listings/1
  # DELETE /listings/1.xml
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to(listings_url) }
      format.xml  { head :ok }
    end
  end
end
