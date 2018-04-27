class Api::V1::SessionsController < ApplicationController

  def create
    if session_params[:email].present?
      user = User.find_by_email(session_params[:email])
      if user && user.valid_password?(session_params[:password])
        sign_in user, store: false
        user.generate_auth_token
        user.save!
        render json: user, status: 200
      else
        render json: {errors: 'Invalid email or password'}, status: 422
      end
    elsif session_params[:phone_number].present?
      user = User.find_by_phone_number(session_params[:phone_number])
      if user.valid_password? session_params[:password]
        sign_in user, store: false
        user.generate_auth_token
        user.save!
        render json: user, status: 200
      else
        render json: {errors: 'Invalid email or password'}, status: 422
      end
    else
      render json: {errors: 'No email or phone provided'}, status: 422
    end
  end


  def destroy
    if params[:id].present? && (u = User.find_by_auth_token(params[:id]))
      u.generate_auth_token
      u.save!
      head 204
    else
      render json: {errors: "User not present"},status: 500
    end
  end

  private
  def session_params
    params.require(:sessions).permit(:email, :phone_number,:password)
  end
end
