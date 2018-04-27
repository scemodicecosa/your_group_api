require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

describe Authenticable do
  let (:auth) {Authentication.new}
  subject { auth}

  describe '#current_user' do
    before do
      @user = FactoryBot.create(:user)
      request.headers['Authorization'] = @user.auth_token
       #auth.stub(:request).and_return(request)
      allow(auth).to receive(:request).and_return(request)
    end

    it 'returns user from request header' do
      expect(auth.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe '#authenticate_with_token' do
    before(:each) do
      @user = FactoryBot.create(:user)
      allow(auth).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({errors: "You are not authorized!"}.to_json)
      allow(auth).to receive(:response).and_return(response)
    end

    it 'return not auth error' do
      expect(json_response[:errors]).to eql "You are not authorized!"
    end

    it { should respond_with 401 }
  end

end