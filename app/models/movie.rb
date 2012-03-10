class Movie < ActiveRecord::Base
	def Movie.all_ratings
		@all_ratings =[]
			self.all(:select => "DISTINCT(rating)").
				each { |r| @all_ratings << r.rating }
		return @all_ratings
	end
end
