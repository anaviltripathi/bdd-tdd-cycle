# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
     @movie = Movie.find_by_title(movie['title'])
     if @movie.nil?
	@movie = Movie.create!(movie)
     else
	@movie.update_attributes!(movie) if @movie != movie
     end  

  end
  #flunk "Unimplemented"
end

Then /^the director of "([^"]*)" should be "([^"]*)"/ do |t, d|
  Movie.find_by_title(t)[:director].should == d
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.

  page.body.delete("\n").should =~ /#{e1}(.+)#{e2}/

  # flunk "Unimplemented"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |r| 
	step %{I #{uncheck}check "ratings_#{r}"}
  end

  # flunk "Unimplemented"
end

When /I press the Refresh button/ do
   step %{I press "ratings_submit"}
end

Then /I should (not )?see movies with ratings: (.*)/ do |nosee, list| 
   @movies = Movie.find_all_by_rating(list.split(%r{,\s*}))
   @movies.each do |m|
	step %{I should #{nosee}see "#{m["title"]}"}
   end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |m|
	step %{I should see "#{m["title"]}"}
  end

  rows = all('//table/tbody/tr').count
  rows.should == Movie.all.count

  # flunk "Unimplemented"
end


