class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.xml
  require "net/http"
  require "nokogiri"
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
    @listing = get_item_from_freecycle_oakland(params[:item])
    respond_to do |format|
      # Not sure how this format stuff works - need to test this. snapfresh was using an object, but here I'm using a non @-sign hash...
      format.html # show.html.erb
      format.xml  { render :xml => @listing}
      format.text { render :text => @listing.to_enum(:each_with_index).map{|r, i| r.info = "#{i+1}: #{r.info}\n"}.join("\n\n")}
    end
  end

  def get_item_from_freecycle_oakland(item)
    url = URI.parse('http://groups.freecycle.org/oaklandfreecycle/posts/search?')
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data({
            "search_words"=>item,
            "include_offers"=>"on",
            "include_wanteds"=>"off",
            "date_start"=>"2011-07-01",
            "date_end"=>"2011-09-15",
            "resultsperpage"=>"3"
        })
    #puts "http://groups.freecycle.org/oaklandfreecycle/posts/search?" + request.body
    response = Net::HTTP.new(url.host, url.port).start {|http| http.request(request)}
    doc = Nokogiri::HTML.parse(response.body)
    info = ""
    re1='((?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|Tues|Thur|Thurs|Sun|Mon|Tue|Wed|Thu|Fri|Sat))'	# Day Of Week 1
    re2='.*?'	# Non-greedy match on filler
    re3='((?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Sept|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?))'	# Month 1
    re4='.*?'	# Non-greedy match on filler
    re5='(\\d)'	# Any Single Digit 1
    re6='.*?'	# Non-greedy match on filler
    re7='((?:(?:[0-1][0-9])|(?:[2][0-3])|(?:[0-9])):(?:[0-5][0-9])(?::[0-5][0-9])?(?:\\s?(?:am|AM|pm|PM))?)'	# HourMinuteSec 1
    re8='.*?'	# Non-greedy match on filler
    re9='((?:(?:[1]{1}\\d{1}\\d{1}\\d{1})|(?:[2]{1}\\d{3})))(?![\\d])'	# Year 1
    rereal=(re1)
    redate=(re1+re2+re3+re4+re5+re6+re7+re8+re9)
    mdate=Regexp.new(redate,Regexp::IGNORECASE);
    m=Regexp.new(rereal,Regexp::IGNORECASE);
    datelistingstr = ""
    foo = ""
    itemhash = doc.search('td').map do |td|
    #info = info + td.text
      if td.text != " "
        if mdate.match(td.text)
          #dayofweek1=mdate.match(td.text)[1];
          #month1=mdate.match(td.text)[2];
          #d1=mdate.match(td.text)[3];
          #time1=mdate.match(td.text)[4];
          #year1=mdate.match(td.text)[5];
          datelistingstr = td.text
          foo = ""
          #puts "date: " + datelistingstr
        else
          #puts "date: " + datelistingstr + " , item: " + td.text
          { :dateoflisting => datelistingstr, :listing => td.text }
        end
      end
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
