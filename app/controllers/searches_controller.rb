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
    @listing = Search.find(params[:id]).current_results
    @group_name = Search.find(params[:id]).group_name
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
    @search = current_user.searches.new(params[:search])
    
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
    @listing = Search.new(params[:search]).current_results
    @groupname = params[:search][:group_name]
    respond_to do |format|
      # Not sure how this format stuff works - need to test this. snapfresh was using an object, but here I'm using a non @-sign hash...
      format.html # show.html.erb
      format.xml  { render :xml => @listing}
      format.text { render :text => @listing.to_enum(:each_with_index).map{|r, i| r.info = "#{i+1}: #{r.info}\n"}.join("\n\n")}
    end
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
