class Api::V1::SessionsController < ApplicationController

  before_action :authenticate_with_token!, only: [:destroy]
  def create
    if session_params[:email].present?
      user = User.find_by_email(session_params[:email])
      if user && user.valid_password?(session_params[:password])
        sign_in user, store: false
        user.generate_auth_token
        user.save!
        render json: {auth_token: user.auth_token}, status: 200
      else
        render json: {errors: 'Invalid email or password'}, status: 422
      end
    elsif session_params[:phone_number].present?
      user = User.find_by_phone_number(session_params[:phone_number])
      if user.valid_password? session_params[:password]
        sign_in user, store: false
        user.generate_auth_token
        user.save!
        render json: {auth_token: user.auth_token}, status: 200
      else
        render json: {errors: 'Invalid phone or password'}, status: 422
      end
    else
      render json: {errors: 'No email or phone provided'}, status: 500
    end
  end


  def destroy
    current_user.generate_auth_token
    if current_user.save
      head 204
    else
      render json: {errors: "Can't logout"}, status: 422
    end
  end

  private
  def session_params
    params.require(:sessions).permit(:email, :phone_number,:password)
  end
end
