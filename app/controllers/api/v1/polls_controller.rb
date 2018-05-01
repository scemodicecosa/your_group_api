class Api::V1::PollsController < ApplicationController

  before_action :authenticate_with_token!, only: [ :create, :vote]

  def create
    if current_user.is_admin_in? params[:group_id]
      @poll = Poll.new(polls_params)
      @poll.user = current_user
      @poll.group_id = params[:group_id]
      @poll.answers = params[:polls][:answers].to_a
      if @poll.save
        render json: {id: @poll.id}, status: 201
      else
        render json: {errors: @poll.errors}, status: 400
      end
    else
      render json: {errors: "You are not an admin!"}, status: 401
    end

  end

  def vote
    @poll = Poll.find(params[:poll_id])
    if current_user.is_in? @poll.group_id
      vote = Vote.where(user_id: current_user.id, poll_id: @poll.id).first_or_initialize

      if vote.update(answer: params[:vote])
        render json: @poll.get_votes, status: 200
      else
        render json: {errors: vote.errors }, status: 400
      end
    else
      render json: {errors: "You are not in group"}, status: 401
    end
  end




  def polls_params
    params.require(:polls).permit(:question, :answers)
  end

end
