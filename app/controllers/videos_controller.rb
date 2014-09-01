class VideosController < ApplicationController

	before_action :load_course

	def index
		@videos = @course.videos.all
	end

	def show
		@video = @course.videos.find(params[:id])
	end

	def new
		@video = @course.videos.build
	end

	def create
		@video = @course.videos.build(video_params)
	end

	private

		def video_params
			params.require(:video).permit(:title, :picture)
		end

		def load_course
			@course = Course.find(params[:course_id]) rescue nil
			if !@course
				redirect_to root_path, alert: "Course not found."
			end
		end
end