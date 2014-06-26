class ProfilesController < ApplicationController

	before_action :signed_in_user, 	only: [:create, :destroy]
	before_action :correct_user, 		only: :destroy

	def create
		@profile  = current_user.profile_user.build(profile_params)
		@course = Course.find_by(_id: @profile.course_id)
		if @profile.save
			flash[:success] = "Your register was successful!"
			redirect_to course_path(@course)
		else
			redirect_to root_path
		end
	end

	def destroy
		@profile.destroy
		flash[:success] = "Unregister successful."
		redirect_to root_path
	end


	private

		def profile_params
			params.require(:profile).permit(:course_id)
		end

		def correct_user
			@profile = current_user.profile_user.find_by(id: params[:id])
			redirect_to root_path if @profile.nil?
		end
end