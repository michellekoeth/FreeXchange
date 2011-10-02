require 'net/http'
require 'mechanize'

module Freecycle

  def itemlistinglogin(group_name,number)
    password = ENV['FEX']
    fcuser = ENV['FCUSER']
    link = "http://my.freecycle.org/login?username=" + fcuser + "&pass=" + password +"&referer=http://groups.freecycle.org/" + group_name + "/posts/" + number
    uri = URI.parse(link)
    response = Net::HTTP.get_response(uri)
    # Freecycle is doing a redirect with my above login URL, so we must follow the redirect
    case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then response = Net::HTTP.get_response(URI.parse(response['location']))
      else
        response.error!
    end
    puts "uri is : " + link            # => 301
    parsed = parse_onelisting(response.body)
  end

  def respondtoofferFC(username,password,group_name,itemnumber)
    #MMK to put mechanize code here for responding to an offer which is on the freecycle site itself
  end
  
    def respondtoofferFCYG(username,password,group_name,itemnumber)
    #MMK to put mechanize code here for responding to an offer which is on a freecycle yahoo group
  end
  
  def listings(group_name,options)
    query = {
      "include_offers"=>"on",
      "include_wanteds"=>"off",
      "date_start"=>(Date.today-2.weeks).to_s,
      "date_end"=>Date.today.to_s,
      "resultsperpage"=>"3"
    }.merge(options)
    raise "missing required option: search_words" unless options["search_words"].present?

    result = retrieve_listings(group_name, query)
    #The below debug code will take the response output and put it into a file - output.html
    aFile = File.new("output.html", "w")
    aFile.write(result.body)
    aFile.close
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
    ret = {"number"=>trs[1].css("td")[0].css("text()")[0].text, 
            # tr[2] just lists that it is an offer - we can skip
            "subject"=>trs[3].css("td")[0].css("text()")[0].text,
            "neighborhood"=>trs[4].css("td")[0].css("text()")[0].text,
            "description"=>trs[5].css("td")[0].css("text()")[0].text,
            "date"=>trs[6].css("td")[0].css("text()")[0].text
          }
  end

end