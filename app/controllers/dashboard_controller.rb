class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update, :show]
  # GET /dashboard
  # GET /dashboard.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /dashboard
  def show
  @user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

end
