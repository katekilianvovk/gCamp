class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User was successfully created"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.save(user_params)
      redirect_to users_path, notice: "User was successfully updated"
    else

    end
  end

  def destroy
    User.destroy(params[:id])
    redirect_to users_path, notice: "User was successfully deleted"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end