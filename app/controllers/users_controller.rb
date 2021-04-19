class UsersController < ApplicationController
  before_action :grab_user, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:show, :index, :new]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5) # User.all
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:alert] = "User account and all associated articles deleted."
    redirect_to articles_path
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def grab_user
    @user = User.find(params[:id])
    #if 
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can only edit or delete your own accountå"
      redirect_to @user
    end
  end

end