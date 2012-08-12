# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should (not )?see "(.*)" before "(.*)"/ do |should_not_see, e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  if should_not_see
    (page.body.index(e1) > page.body.index(e2)).should be_true
  else
    (page.body.index(e1) < page.body.index(e2)).should be_true
  end
end

Given /I (un)?check the following ratings: (.*)$/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.gsub(/(,|and)/, "").split.each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}  
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end
end

Then /^I should (not )?see movies rated: (.*)$/ do |should_not_see, rating_list|
  
  rating_list.gsub(/(,|and)/, "").split.each do |rating|      
    movies = Movie.where("rating = ?", rating)
    movies.each do |movie|
      if should_not_see
        step %Q{I should not see "#{movie.title}"}
      else
        step %Q{I should see "#{movie.title}"}
      end
    end
  end
end

Given /^I (un)?check all ratings$/ do |uncheck|
  Movie.all_ratings.each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end  
end

Then /^I should see all movies$/ do
  page.all('tbody#movielist tr').count.should == Movie.count
end

Then /^I should not see any movie$/ do
  page.all('tbody#movielist tr').count.should == 0
end