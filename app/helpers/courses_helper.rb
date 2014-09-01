module CoursesHelper
	
	def example_comments(course)

		if course.comments.empty?
			nil
		else
			list_comments = course.comments.all.to_a
			number_comments = 4
			list_comments.count > number_comments ? list_comments.sample(number_comments) : list_comments
		end
	end
end