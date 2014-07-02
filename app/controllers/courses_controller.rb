class CoursesController < ApplicationController
	
	before_action :signed_in_user,	only: [:create, :destroy]
	before_action	:correct_user,		only: :destroy

	def index
		@courses = Course.all.paginate(page: params[:page], per_page: 8)
	end

	def new	
		if signed_in?
			@course  = current_user.author_of.build 
		else
			redirect_to signin_path, notice: "Please sign in."
		end
	end

	def create
		@course  = current_user.author_of.build(course_params)
		if @course.save
			flash[:success] = "Course created!"
			redirect_to current_user
		else
			render 'new'
		end
	end

	def destroy
		@course.destroy
		flash[:success] = "Course deleted."
		redirect_to current_user
	end

	def show
		@course = Course.find(params[:id])
		@profile = Profile.find_by(user_id: current_user.id, course_id: @course.id) if signed_in?
	end

	
	private

		def course_params
			params.require(:course).permit(:title, :description)
		end

		def correct_user
			@course = current_user.author_of.find_by(id: params[:id])
			redirect_to current_user if @course.nil?
		end

		def comments
			
		end
end