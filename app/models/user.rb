class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  has_many :searches
  has_many :listings
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :group_name, :phonenumber

  def notify_about_listings(search,new_listings)
    message = "You have #{new_listings.length} results for '#{search.search_words}'"
    message += ": "
    message += new_listings.map {|l| "#{l[:title]} (#{l[:neighborhood]})"}*", "
    #puts "Sending flocky message"
    $outbound_flocky.message(ENV['APP_NUMBER'], message, [self.phonenumber])
    # Below is for debugging
    #$outbound_flocky.message '5106068706','Test Message','6095778790'
  end
end