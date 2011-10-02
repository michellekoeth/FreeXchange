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

  def new_results
    # must be a saved search.
    return nil unless self.persisted? && self.updated_at? 
    #get results that occured since the last time we were saved
    results = Freecycle::listings(self.group_name, "search_words"=>self.search_words, "date_start" => self.updated_at.to_date.to_s)
    # Only return results that are newer than our last returned result.
    results = results.take_while {|r| r[:number].to_i > self.last_itemnum.to_i} if self.last_itemnum
    results
  end
end
