desc "run all saved searches, and notify users of new results"
task :update_saved_searches => :environment do
  searches = Search.all.select {|s| s.user.present? && s.search_words.present?}
  searches.each do |s|
    new = s.new_results
    unless new.empty?
      #TODO: send notification to user
      s.update_attribute(:last_itemnum, new.first[:number])
    end
  end
end