desc "Fill the fcgroups table with live data"
task :fill_fcgroups => :environment do
    agent = Mechanize.new
    agent.get("http://my.freecycle.org/login")
    form = agent.page.forms.first
    form.username = ENV['FCUSER']
    form.pass = ENV['FEX']
    form.submit
    linkz = agent.page.links
    re1='((?:[a-z][a-z]+))'	# Word 1
    re2='(.)'	# Any Single Character 1
    re3='(.)'	# Any Single Character 2
    re4='(.)'	# Any Single Character 3
    re5='((?:[a-z][a-z\\.\\d\\-]+)\\.(?:[a-z][a-z\\-]+))(?![\\w\\.])'	# Fully Qualified Domain Name 1
    re6='.*?'	# Non-greedy match on filler
    re7='((?:[a-z][a-z]+))'	# Word 2
    re=(re1+re2+re3+re4+re5+re6+re7)
    m=Regexp.new(re,Regexp::IGNORECASE)
    linkz.each do |l|
        if l.text != "Log out" && l.text != "My Groups" && l.text != "My Freecycle" && l.text != "My Info" &&
        l.text != "My Groups" && l.text != "My Posts" && l.text != "The Freecycle Network logo" &&
        l.text != "status page" && l.text != "All Items" && l.text != "Offers" && l.text != "Wanteds" &&
        l.text != "Group Info" && l.text !="Change password" && l.text != "Change My Freecycle email address" &&
        l.text != "Delete account"
           if m.match(l.href)
                word2 = m.match(l.href)[6];
                #puts "Group Name: " + word2
                if Fcgroup.find_by_group_name(word2).nil?
                    #Fcgroup.new({:group_name=>word2,"group_name_human"=>l.text,"nativeToryahooF"=>"True","groupurl"=>l.href})
                    #Fcgroup.save
                    puts "Wrote new fcgroup - " + l.text
                end
                #puts "Human Group Name: " + l.text
            end
        end
    end
end