class Api::V1::GroupsController < ApplicationController

  before_action :authenticate_with_token!, only: [:show, :create]
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
    group.add_admin(current_user.id)
    if group.save
      render json: group, status: 201
    else
      render json: {errors: group.errors}, status: 400
    end
  end

  def add_user
    role = Role.where(group_id: params[:group_id], user: current_user).first
    if role && role.admin
      r = role.group.add_user(params[:user_id])

    else
      render json: {errors: "You are not admin"}, status: 401
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end

end
