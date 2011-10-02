require 'net/http'
require 'mechanize'

module Freecycle

  def itemlistinglogin(group_name,number)
    # Use Mechanize to login. Some freecycle groups require that you are logged in to view the details of a listing
    agent = Mechanize.new
    agent.get("http://my.freecycle.org/login")
    # The first form is the login form
    form = agent.page.forms.first
    form.username = ENV['FCUSER']
    form.pass = ENV['FEX']
    form.submit
    #form.submit # may need to do twice to work - was giving me an error in rails c unless I did twice??
    agent.get("http://groups.freecycle.org/" + group_name + "/posts/" + number)
    trs = agent.page.search("tr") 
    ret = {"number"=>trs[1].css("td")[0].css("text()")[0].text, 
            # trs[2] and 3 just lists that it is an offer and other meta data- we can skip
            "subject"=>trs[4].css("td")[0].css("text()")[0].text,
            "neighborhood"=>trs[5].css("td")[0].css("text()")[0].text,
            "description"=>trs[6].css("td")[0].css("text()")[0].text,
            "date"=>trs[7].css("td")[0].css("text()")[0].text
          }
  end
  
  def respondtoofferFC(group_name,number, phonenumber)
    # Responds to an offer with a canned message telling the offeror to followup via phone number
    # Use Mechanize to login. Some freecycle groups require that you are logged in to view the details of a listing
    agent = Mechanize.new
    agent.get("http://my.freecycle.org/login")
    # The first form is the login form
    form = agent.page.forms.first
    form.username = ENV['FCUSER']
    form.pass = ENV['FEX']
    form.submit
    # now get the detailed listing page
    agent.get("http://groups.freecycle.org/" + group_name + "/posts/" + number)
    trs = agent.page.search("tr")
    # keep track of the offeror so we can tell the user who it was
    offeror = trs[2].css("td")[0].css("text()")[0].text
    # And get the first form from this new form since that is the message reply form
    #form2 = agent.page.forms.first
    # Now set the message for this form and submit
    #form2.reply_body="Hi, I am interested in your Freecycle listing. I do not have frequent access to email though.
    #Can you call me or text message me at " + phonenumber + " to let me know if the item is still available,
    #and schedule a pickup? Thanks so much!"
    #form2.submit
    # Notify user that a reply has been sent to the offeror
    #$outbound_flocky.message(ENV['APP_NUMBER'], "At your request, a message on Freecycle "+group_name+", has been sent to "+offeror+" about Post ID "+number+".", phonenumber)
  end
  
  def respondtoofferFCYG(username,password,group_name,itemnumber)
    #MMK to put mechanize code here for responding to an offer which is on a freecycle yahoo group
    # Future development / Wishlist
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
    #aFile = File.new("output.html", "w")
    #aFile.write(result.body)
    #aFile.close
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
end