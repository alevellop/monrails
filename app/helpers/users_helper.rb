module UsersHelper

	def author?(course)
		course.author.id == current_user.id
	end

	def registered?(course)
		!current_user.profile_user.find_by(course_id: course.id).nil?
	end
end
