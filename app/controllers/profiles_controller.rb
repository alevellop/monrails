class ProfilesController < ApplicationController

	before_action :signed_in_user, 	only: [:create, :destroy]

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
		profile = Profile.find(params[:id])
		profile.destroy
		flash[:success] = "Unregister successful."
		redirect_to root_url
	end

	private

		def profile_params
			params.require(:profile).permit(:course_id)
		end
end