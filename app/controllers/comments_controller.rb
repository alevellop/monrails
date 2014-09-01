class CommentsController < ApplicationController

	before_action :load_course
	before_action :delete_comment, only: :destroy

  def new
  	@comment = @course.comments.build
  end

  def create
  	@comment = @course.comments.build(comment_params)

  	if signed_in?
  		if @comment.save
  			flash[:success] = "Comment was created!"
	  	else
	  		flash[:alert] = "Comment can't be empty or too long."
	  	end
	  	redirect_to @course
  	else
  		redirect_to signin_path, notice: "Sign in, please."
  	end
  end

  def destroy
  	@comment.destroy
  	redirect_to @course, success: "Comment was deleted."
  end

  
  private

  	def comment_params
  		params.require(:comment).permit(:body)
  	end

		def load_course
			@course = Course.find(params[:course_id]) rescue nil
      if !@course
        redirect_to root_path, alert: "Course not found."
      end
		end

		def delete_comment
			@comment = @course.comments.find(params[:id])
		end
end