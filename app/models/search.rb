require 'freecycle'
include Freecycle

class Search < ActiveRecord::Base
  belongs_to        :user
  has_many          :listings

  #group name can be overriden by us, or we can default to our user's group name, if we have a user.
  def group_name
    attributes["group_name"].presence || (user && user.group_name)
  end

  def current_results
    Freecycle::listings(self.group_name, "search_words"=>self.search_words)
  end
end
