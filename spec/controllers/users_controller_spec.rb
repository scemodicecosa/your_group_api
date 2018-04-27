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

  describe 'Trying to make an action with authorization' do
    context 'the user is authenticated with token' do
      before (:each) do
        @user = FactoryBot.create(:user)
        api_auth_token(@user.auth_token)
        patch :update, params: {id: @user.id, email: 'leonardosagratella@yahoo.it'}, format: :json
      end

      it 'should be allowed to update his profile' do
        expect(json_response[:email]).to eql "leonardosagratella@yahoo.it"
      end
      it { should respond_with 200}
    end
    context 'the user is not authenticated' do
      before (:each) do
        @user = FactoryBot.create(:user)
        #api_auth_token(@user.auth_token)
        patch :update, params: {id: @user.id, email: 'leonardosagratella@yahoo.it'}, format: :json
      end

      it 'should receive an error message' do
        expect(json_response[:errors]).to include "You are not authorized"
      end
      it { should respond_with :unauthorized}
    end
  end
end
