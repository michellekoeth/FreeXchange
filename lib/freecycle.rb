require 'net/http'
require 'mechanize'

module Freecycle

  def itemlistinglogin(username,password,group_name,itemnumber)
    loguinandshowapostURI = URI.parse("http://my.freecycle.org/login?username=" + username + "&pass=" + password + "&referer=http://groups.freecycle.org/" + group_name + "/posts/" + itemnumber)
    # loguinandshowposts = "http://my.freecycle.org/login?username=" + username + "&pass=" + password + "&referer=http%3A%2F%2Fgroups.freecycle.org%2F" + group_name
    result = Net::HTTP.post_form(loguinandshowapostURI)
    parsed = parse_onelisting(result.body)
  end

  def respondtoofferFC(username,password,group_name,itemnumber)
    #MMK to put mechanize code here for responding to an offer which is on the freecycle site itself
  end
  
    def respondtoofferFCYG(username,password,group_name,itemnumber)
    #MMK to put mechanize code here for responding to an offer which is on a freecycle yahoo group
  end
  
  def listings(group_name,options)
    query = options.merge({
      "include_offers"=>"on",
      "include_wanteds"=>"off",
      "date_start"=>(Date.today-2.weeks).to_s,
      "date_end"=>Date.today.to_s,
      "resultsperpage"=>"3"
    })
    raise "missing required option: search_words" unless options["search_words"].present?

    result = retrieve_listings(group_name, query)
    parsed = parse_listings(result.body)
  end

  def retrieve_listings(group_name,query)
    url = URI.parse("http://groups.freecycle.org/#{group_name}/posts/search")
    Net::HTTP.post_form(url,query)
  end

  def parse_listings(listings_html)
    doc = Nokogiri::HTML.parse(listings_html)
    doc.css("tr").map do |tr|
      tds = tr.css("td")
      date = tds[0].css("text()")[2].text
      number = tds[0].css("text()")[3].text
      title = tds[1].css("text()")[1].text
      neighborhood = tds[1].css("text()")[2].text
      {
        :date=>Time.parse(date),
        :number=>number.gsub(/\D/,''),
        :title=>title.strip,
        :neighborhood=>neighborhood.strip[1..-2] #strip surrounding parentheses
      }
    end
  end
  
  def parse_onelisting(listing_html)
    # This function will parse out the detailed data for one listing
    doc = Nokogiri::HTML.parse(listing_html)
    trs = doc.css("tr") #gives you an array of all the trs
    # skip the first one - so use the index 1 (index 0 is the first one)
    #tds = tr[1].css("td")
    #number = tds[0].css("text()")[0].text
    #poster = tds[1].css("text()")[0].text
    number = tr[1].css("td")[0].css("text()")[0].text
    poster = tr[2].css("td")[0].css("text()")[0].text
    # tr[3] just lists that it is an offer - we can skip
    subject = tr[4].css("td")[0].css("text()")[0].text
    neighborhood = tr[5].css("td")[0].css("text()")[0].text
    description = tr[6].css("td")[0].css("text()")[0].text
    date = tr[7].css("td")[0].css("text()")[0].text
    {
      :date=>Time.parse(date),
      :number=>number.gsub(/\D/,''),
      :neighborhood=>neighborhood
      :description=>description
      :poster=>poster
      :subject=>subject
    }
  end

end