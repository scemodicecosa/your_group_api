class Api::V1::UsersController < ApplicationController

  #include Authenticable

  before_action :authenticate_with_token! , only: [:update]
  respond_to :json

  def show
    respond_with(User.find(params[:id]))
  end

  def update
    u = current_user
    if u.update(user_params)
      render json: u, status: 201
    else
      render json: {errors: u.errors}, status: 422
    end

  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      head 201
    else
      render json: {errors: @user.errors}, status:  400
    end
  end

  def user_params
    params.require(:users).permit(:email, :phone_number)
  end

  def create_user_params
    params.require(:users).permit(:email, :phone_number, :password, :password_confirmation)
  end

end
