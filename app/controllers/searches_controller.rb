class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.xml
  def index
    #@searches = Search.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @searches }
    #end
  end

  # GET /searches/1
  # GET /searches/1.xml
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.xml
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to(@search, :notice => 'Search was successfully created.') }
        format.xml  { render :xml => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.xml
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to(@search, :notice => 'Search was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /searches/finditem/:item
  def finditem
    listing = get_item_from_freecycle_oakland(params[:item])
    respond_to do |format|
      # Not sure how this format stuff works - need to test this. snapfresh was using an object, but here I'm using a non @-sign hash...
      format.html # show.html.erb
      format.xml  { render :xml => listing}
      format.text { render :text => listing.to_enum(:each_with_index).map{|r, i| r.info = "#{i+1}: #{r.info}\n"}.join("\n\n")}
    end
  end

  def get_item_from_freecycle_oakland(item)
    baseurl = "http://groups.freecycle.org/oaklandfreecycle/posts/search?search_words="+item+"&include_offers=on&include_wanteds=off&date_start=2011-02-01"
    # Freecycle returns results in an HTML format thats gonna have to be parsed
    url = URI.parse(baseurl)
    request = Net::HTTP::Post.new(url.path)
    response = Net::HTTP.new(url.host, url.port).start {|http| http.request(request)}
    doc = Nokogiri::HTML.parse(response.body)
    doc.search('td').each do |td|
  #item = td.search('strong').text
  #date = td.search('').text
      info = td.text
  #date = td.xpath("//OutputGeocode/Longitude").text;
  #itemtitle = td.
      itemhash = { :listing => info }
    end
    return itemhash
  end

  # DELETE /searches/1
  # DELETE /searches/1.xml
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to(searches_url) }
      format.xml  { head :ok }
    end
  end
end
