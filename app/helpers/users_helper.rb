module UsersHelper

	def author?(course)
		course.author.id == current_user.id
	end
end
