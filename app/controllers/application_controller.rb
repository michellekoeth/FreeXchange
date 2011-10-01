class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for(resource)
    #go to the dashboard for this user
    dashboard_show_path
  end
end
