class Api::V1::ActionsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :assign]


  def create
    if current_user.is_admin_in?(params[:id])
      if action_params[:user_id].present? && !is_in?(action_params[:user_id],params[:id])
        render json: {errors: "user not in group"}, status: 400
      else
        @action = Action.new(action_params)
        @action.group_id = params[:id]
        if @action.save
          render json: {id: @action.id}, status: 201
        else
          render json: {errors: @action.errors}, status: 400
        end
      end
    else
      render json: {errors: "You are not admin"}, status: 401
    end
  end

  def assign
    begin
      action = Action.find(params[:action_id])
    rescue ActiveRecord::RecordNotFound
      render json: {errors: "Action does not exist"}, status: 404 and return
    end

    if action.group_id != params[:id].to_i
      render json: {errors: "Action is not in group"}, status: 400 and return
    end

    unless is_in?(params[:user_id], params[:id])
      render json: {errors: "User is not in group"}, status: 400 and return
    end

    if action.user_id && action.accepted
      render json: {errors: "The action is already assigned"}, status: 400 and return

    end
    if current_user.is_admin_in?(params[:id]) || current_user.id == params[:user_id].to_i
      action.user_id = params[:user_id]
      if action.save
        head 204
      else
        render json: {errors: action.errors}, status: 400 and return
      end
    else
      render json: {errors: "You are not admin"}, status: 401
    end


  end
  private
  def action_params
    params.require(:actions).permit(:name,:description,:user_id)
  end
end
