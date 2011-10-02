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
    # There are problems with this code since updated_at is not being auto populated when the search is saved.
    # also the group_name is not saving with the search again, so need to look into that
    #return nil unless self.persisted? && self.updated_at? #must be a saved search.
    # The next line also assumes that there is an updated_at also, and so fails
    #results = Freecycle::listings(self.group_name, "search_words"=>self.search_words, "date_start" => self.updated_at.to_date.to_s)
    # the next line MMK added just for debugging - it should be fixed
    results = Freecycle::listings(self.group_name, "search_words"=>self.search_words)
    # Havent testing this last line yet. It seems to not send out result if its already been sent out
    # results = results.take_while {|r| r[:number].to_i > self.last_itemnum.to_i} if self.last_itemnum
    # flocky vars need to be set - don't think they have been
    results
  end
end
