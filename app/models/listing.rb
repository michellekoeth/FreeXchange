class Listing < ActiveRecord::Base
  belongs_to              :searches
    
  def detail_listing
    Freecycle::itemlistinglogin(self.group_name, self.number)
  end
end
