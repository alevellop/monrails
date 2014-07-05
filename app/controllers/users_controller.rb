class UsersController < ApplicationController

  before_action :signed_in_user,        only: [:edit, :update, :destroy]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: [:index, :destroy]
  before_action :signed_in_user_filter, only: [:new, :create]

  def index
    @users = User.all.paginate(page: params[:page], per_page: 20)
  end

	def show
    if signed_in?
      @user = admin_user? ? User.find(params[:id]) : current_user
      @courses  = @user.author_of.paginate(page: params[:created_page], per_page: 5)
      @courses_registered = all_profiles.paginate(page: params[:registered_page], per_page: 5)
    else
      redirect_to signin_path, notice: "Please sign in."
    end
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
      if params[:avatar]
        params.require(:user).permit(:avatar, :name, :email, 
                                  :password, :password_confirmation)
      else
        params.require(:user).permit(:name, :email, 
                                  :password, :password_confirmation)
      end
  	end

    def all_profiles
      @all_courses = []

      @profiles = current_user.profile_user.all.to_a

      @profiles.each do |profile|
        @all_courses << Course.find_by(_id: profile.course_id)
      end
      @all_courses
    end

    # Before filters

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
