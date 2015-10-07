class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date, :director

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
	
#  def self.similar_directors(director)
#  	Movie.find_all(:director => director)
#  end

end

