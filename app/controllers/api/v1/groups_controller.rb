class Api::V1::GroupsController < ApplicationController

  before_action :authenticate_with_token!, only: [:show, :create, :add_user,:remove_user]
  respond_to :json


  '''
    GET /v1/v1/groups/:id
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

  '''
    POST /v1/v1/groups/
    Create a group and add the current_user as admin
    params { group: {name (pefforza) , description}
    returns 201 when successfully created new group
    return 400 when is not created
  '''

  def create
    group = Group.new(group_params)
    if group.save
      group.add_user(current_user.id,true)
      render json: group, status: 201
    else
      render json: {errors: group.errors}, status: 400
    end
  end


  '''
    POST /v1/v1/groups/add_user
    Add the user_id to group_id, if admin set the user to admin
    params { user_id, group_id, admin=false}
    returns 201 when added the user
    returns 401 if current_user is not an admin for the group
  '''
  def add_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && role.admin
      if params[:admin].to_s == "true"
        role.group.add_user(params[:user_id], true )
      else
        role.group.add_user(params[:user_id])
      end

    else
      render json: {errors: "You are not admin"}, status: 401
    end
  end

  '''
    POST /v1/v1/groups/remove_user
    Remove user_id from group_id, if current_user is admin or user_id equals current_user
    params { user_id, group_id}
    returns 201 when added the user
    returns 401 if current_user is not an admin for the group or the one to delete
  '''
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
