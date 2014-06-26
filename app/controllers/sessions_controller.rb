class SessionsController < ApplicationController

	def new
		
	end

	def create
		user = User.find_by(email: params[:email].downcase)

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			sign_in user
			flash[:success] = "Sign in successful."
			redirect_back_or user
		else
			flash.now[:alert] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		flash[:success] = "Sign out successful."
		redirect_to root_url
	end
end
