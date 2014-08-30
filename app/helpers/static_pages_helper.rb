module StaticPagesHelper

	def newest_courses
		length = 4
		
		length = Course.count if Course.count < 4
		
		Course.all.sort{ |course_one, course_two| course_one.created_at <=> course_two.created_at }.to_a[-length, length].reverse
	end

	def popular_courses
		length = 4

		length = Course.count if Course.count < 4

		Course.all.sort{ |course_one, course_two| course_one.profile_course.count <=> course_two.profile_course.count }.to_a[-length, length].reverse
	end
end
