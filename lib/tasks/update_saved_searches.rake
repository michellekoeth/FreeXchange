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
      s.user.notify_about_listings(s,new)
      s.update_attribute(:last_itemnum, new.first[:number])
    end
  end
end