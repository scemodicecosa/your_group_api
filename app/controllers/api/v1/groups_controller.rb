class Api::V1::GroupsController < ApplicationController

  before_action :authenticate_with_token!, only: [:show, :create, :add_user]
  respond_to :json


  '''
    GET /api/v1/groups/:id
    returns info about the group
    return 401 "Not a member" if user not in group
  '''

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
      render json: group, status: 201
    else
      render json: {errors: group.errors}, status: 400
    end
  end

  def add_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && role.admin
      if params[:admin].to_s == "true"
        role.group.add_user(params[:user_id], true )
      else
        role.group.add_user(params[:user_id], false)
      end

    else
      render json: {errors: "You are not admin"}, status: 401
    end
  end

  def remove_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && (role.admin || params[:user_id].to_i == current_user.id)
      role.group.remove_user(params[:user_id])
    else
      render json: {errors: "You are not admin or in group"}, status: 401
    end
  end
  private
  def group_params
    params.require(:group).permit(:name, :description)
  end

end
