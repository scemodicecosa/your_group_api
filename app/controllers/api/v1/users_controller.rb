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
      render json: u, status: 200
    else
      render json: {errors: "Impossible to update user"}, status: 422
    end

  end

  def user_params
    params.require(:users).permit(:email, :phone_number)
  end

  def current_user
    @current_user ||= User.find_by_auth_token(request.headers["Authorization"])
  end

  def authenticate_with_token!
    render(json: {errors: "You are not authorized!"},status: :unauthorized) unless current_user.present?
  end

end
