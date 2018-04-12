require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = 'application/yourgroup.com.v1' }

  describe 'GET show' do
    before(:each) do
      @user = FactoryBot.create(:user)
      get(:show, params: { id: @user.id }, format: :json)
    end

    it 'returns information about user' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it 'should respond 200 code' do
      should respond_with 200
    end
  end
end
