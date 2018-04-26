class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    respond_with(User.find(params[:id]))
    group = Group.new(name: 'nome',description: 'descrizione')
    group.users
  end

end
