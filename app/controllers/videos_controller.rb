class VideosController < ApplicationController
	
	# def new
	# 	@course = Course.find(params[:course_id])
	# 	@video = @course.videos.build
	# end

	# def create
	# 	@course = Course.find(params[:course_id])
	# 	@video = @course.videos.build(video_params)

	# 	if @video.save
	# 		flash[:notice] = "Video added!"
	# 	else
	# 		redirect_to user_path(@course.author)
	# 	end
	# end


	# private

	# def video_params
	# 	params.require(:video).permite(:title)
	# end
end