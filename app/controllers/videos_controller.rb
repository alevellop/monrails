class VideosController < ApplicationController

	before_filter :check_course!

	def index
		@videos = @course.videos.all
	end

	def show
		@video = @course.videos.find(params[:id])
	end


	def check_course!
		@course = Course.find(params[:course_id]) rescue nil
		if !@course
			redirect_to root_path, alert: "Course not found!"
		end
	end
end