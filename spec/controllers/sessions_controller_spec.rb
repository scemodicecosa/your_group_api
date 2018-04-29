require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'login' do
    before(:each) do
      @user = FactoryBot.create :user
    end

    context 'the user login with email' do

      before(:each) do
        credentials = {email: @user.email, password: '12345678'}
        post :create, params: { sessions: credentials }, format: :json
      end

      it 'should have same auth token' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end



    context 'the user login with phone_number' do

      before(:each) do
        credentials = {phone_number: @user.phone_number, password: '12345678'}
        post :create, params: { sessions: credentials }, format: :json
      end

      it 'should have same auth token' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }

    end

    context 'the user login with wrong_credentials' do

      before(:each) do
        credentials = {email: @user.email, password: '123456786'}
        post :create,params: {sessions: credentials}, format: :json
      end

      it 'should say an error message' do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }

    end
  end

  describe 'logout' do
    context 'correct logout' do
      before(:each) do
        @user = FactoryBot.create(:user)
        #@user.generate_auth_token
        @old_auth = @user.auth_token
        sign_in @user
        api_auth_token(@user.auth_token)
        delete :destroy,params:{}, format: :json
      end

      it 'should change user authentication token' do
        @user.reload
        expect(@user.auth_token).not_to eql @old_auth
      end

      it {should respond_with 204}
    end


  end

end
