class UsersController < ApplicationController
  require 'will_paginate/array'

  before_action :signed_in_user,        only: [:index, :edit, :update, :destroy]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: :destroy
  before_action :signed_in_user_filter, only: [:new, :create]

  def index
    @users = User.all.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])	
	end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to Monrails!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    # User.find(params[:id]).destroy
    # flash[:success] = "User deleted."
    # redirect_to users_url
    user = User.find(params[:id])

    if !current_user?(user)
      
      user.destroy
      flash[:success] = "User deleted."
    else
      flash[:alert] = "You can't delete yourself."
    end
    
    redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  																	:password_confirmation)
  	end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def signed_in_user_filter
      redirect_to root_path, notice: "You are already signed in." if signed_in?
    end
end
