desc "run all saved searches, and notify users of new results"
task :update_saved_searches => :environment do
  searches = Search.all.select {|s| s.user.present? && s.search_words.present?}
  searches.each do |s|
    #puts "search:" + s.search_words
    new = s.new_results
    if new.empty?
      # puts "nada"
    end
    unless new.empty?
      new.each do |n|
        # for every new listing that is returned, creat a listing object, populate it with the result data
        # for that listing, and associate it with the current search.
        l = Listing.new({"search_id"=>s.id, "group_name"=>s.group_name, "neighborhood"=>n[:neighborhood], "number"=>n[:number], "dateposted"=>n[:date], "created_at"=>Time.now.to_s, "updated_at"=>Time.now.to_s})
        l.save
      end
      s.user.notify_about_listings(s,new)
      s.update_attribute(:last_itemnum, new.first[:number])
    end
  end
end