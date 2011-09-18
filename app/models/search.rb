class Search < ActiveRecord::Base
  belongs_to        :users
  has_many          :listings
end
