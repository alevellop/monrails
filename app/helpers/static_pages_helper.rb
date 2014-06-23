module StaticPagesHelper

	def newest_courses
		length = 4
		if Course.count < 4
			length = Course.count
		end
		Course.all.to_a[-length, length].reverse
	end
end
