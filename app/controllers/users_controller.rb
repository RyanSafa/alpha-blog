class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]
before_action :require_user, only: [:edit, :update]
before_action :alread_logged_in?, only: [:new, :create]
before_action :require_same_user, only: [:edit, :update, :destroy]

def new
    @user = User.new
end

def create
    @user = User.new(user_params)
    if @user.save 
        session[:user_id] = @user.id
        flash[:notice] = "Welcome to Ruby Blog, #{@user.username}. You have sucessfully signed up"
        redirect_to articles_path
    else
        render "new"
    end
end

def index
    @users = User.paginate(page: params[:page], per_page: 3)


end


def edit

end

def update
    if @user.update(user_params)
        flash[:notice] = "Your account information was updated"
        redirect_to user_path(@user)
    else
        render 'edit'
    end
end

def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 3)
end

def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Your account and all associated articles are deleted"
    redirect_to root_path
end

private
def set_user
    @user = User.find(params[:id])
end
def user_params
    params.require(:user).permit(:username, :email, :password)
end

def alread_logged_in?
    if logged_in?
        flash[:alert] = "You cannot sign up if have an existing account"
        redirect_to users_path(current_user[:user_id])
    end
end

 def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:alert] = "You can not edit or detroy someone else's profile"
        redirect_to users_path(current_user[:user_id])
      end
    end
    
end