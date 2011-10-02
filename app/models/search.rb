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
    return nil unless self.persisted? && self.updated_at? # must be a saved search.
    # the below line of code is problematic, and it has to do with the date_start variable thats being sent
    # if you just do this call without the date_start variable, the code seems to work OK
    # Talin wrote the below line though, so I'll leave it here for now in case I'm misunderstanding
    # but, just so this thing works, I'm going to use my working substitute for now
    #results = Freecycle::listings(self.group_name, "search_words"=>self.search_words, "date_start" => self.updated_at.to_date.to_s)
    #puts "Group name: " + self.group_name + " Search words: " + self.search_words + " Date Start: " + self.updated_at.to_date.to_s
    # MMK's substitute line:
    results = Freecycle::listings(self.group_name, "search_words"=>self.search_words)
    # Not entirely clear what this line does. It seems to not send out result if its already been sent out
    results = results.take_while {|r| r[:number].to_i > self.last_itemnum.to_i} if self.last_itemnum
    results
  end
end
