class Api::V1::GroupsController < ApplicationController

  before_action :authenticate_with_token!, only: [:show, :create, :add_user,:remove_user,:participants, :update_role, :accept]
  respond_to :json


  def show
    @group = Group.find(params[:id])
    if @group.users.include? current_user
      respond_with(@group)
    else
      render json: {errors: "You are not a member!"}, status: 401
    end
  end


  def create
    group = Group.new(group_params)
    if group.save
      group.add_user(current_user.id,true)
      r = Role.where(user_id: current_user.id, group_id: group.id).first
      r.update!(accepted: true)
      render json: group, status: 201
    else
      render json: {errors: group.errors}, status: 400
    end
  end

  def update
    if current_user.is_admin_in? params[:id]
      group = Group.find(params[:id])
      if group.update(update_params)
        head 201
      else
        render json: {errors: group.errors}, status: 400
      end
    else
      render json: {errors: "you are not admin"}, status: 401
    end
  end

  def add_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && role.admin
      if params[:admin].to_s == "true"
        role.group.add_user(params[:id], true )
      else
        role.group.add_user(params[:id])
      end


    else
      render json: {errors: "You are not admin"}, status: 401
    end
  end


  def remove_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && (role.admin || params[:id].to_i == current_user.id)
      role.group.remove_user(params[:id])
    else
      render json: {errors: "You are not admin or in group"}, status: 401
    end
  end

  def participants
    if current_user.is_in?(params[:id])
      @group = Group.find(params[:id])
      render json: @group.users, status: 200
    else
      render json: {errors: "you are not in group"}, status: 401
    end
  end

  def update_role
    if current_user.is_admin_in?(params[:id])
      r = Role.where(group_id: params[:id], user_id: params[:user_id]).first
      if r.update(role_params)
        head 201
      else
        render json: {errors: r.errors}, status: 400
      end
    else
      render json: {errors: "you are not admin"}, status: 401
    end
  end

  def accept
    r = Role.where(user_id: current_user.id, group_id: params[:id]).first
    if r
      if r.update(accepted: true)
         head 201
      else
         render json: {errors: r.errors}, status: 400
      end
    else
      render json: {errors: "you are not in group"}, status: 401
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end

  def update_params
    params.permit(:name, :description)
  end

  def role_params
    params.permit(:name,:admin)
  end
end
