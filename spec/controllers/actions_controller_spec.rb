require 'rails_helper'

RSpec.describe Api::V1::ActionsController, type: :controller do
  before do
    @group = FactoryBot.create(:group)
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @group.add_user(@user.id,true)
    @group.add_user(@user2.id)
    accept_invite(@user.id,@group.id)
    accept_invite(@user2.id,@group.id)
  end
  describe "POST /groups/:id/actions" do
    context 'admin create an action' do
      before do
        params = {id: @group.id, actions: {name: "azione1", description: "azione nuova"}}
        api_auth_token(@user.auth_token)
        post :create, params: params, format: :json
      end
      it 'create an action' do
        action = Action.find(json_response[:id])
        expect(action.name).to eql "azione1"
        expect(action.description).to eql "azione nuova"
        expect(action.user).to be_nil
      end
      it {should respond_with 201}
    end
    context 'not admin create an action' do
      before do
        params = {id: @group.id, actions: {name: "azione1", description: "azione nuova"}}
        api_auth_token(@user2.auth_token)
        post :create, params: params, format: :json
      end
      it 'doesnt create an action' do
        expect(json_response[:errors]).to include "not admin"
      end
      it {should respond_with 401}
    end
    context 'admin create action with user' do
      before do
        params = {id: @group.id, actions: {name: "azione1", description: "azione nuova", user_id: @user2.id}}
        api_auth_token(@user.auth_token)
        post :create, params: params, format: :json
      end
      it 'create an action' do
        action = Action.find(json_response[:id])
        expect(action.name).to eql "azione1"
        expect(action.description).to eql "azione nuova"
        expect(action.user).to eql @user2
      end
      it {should respond_with 201}
    end
    context 'create action with user but he is not in group' do
      before do
        @user3 = FactoryBot.create(:user)
        params = {id: @group.id, actions: {name: "azione1", description: "azione nuova", user_id: @user3.id}}
        api_auth_token(@user.auth_token)
        post :create, params: params, format: :json
      end
      it 'the user is not in group' do
        expect(json_response[:errors]).to include "not in group"
      end
      it {should respond_with 400}
    end
  end

  describe "POST /groups/:id/action/assign" do
    before do
      @action = FactoryBot.build(:action)
      @action.group = @group
      @action.save!
    end
    context 'admin assigns an action to user' do
      before do
        params = {id: @group.id, action_id: @action.id, user_id: @user2.id}
        api_auth_token(@user.auth_token)
        post :assign, params: params, format: :json
      end
      it 'assign the action to the user' do
        a = Action.find(@action.id)
        expect(a.user_id).to eql @user2.id
      end
      it {should respond_with 204}
    end
    context 'user assigns an action to himself' do
      before do
        params = {id: @group.id, action_id: @action.id, user_id: @user2.id}
        api_auth_token(@user2.auth_token)
        post :assign, params: params, format: :json
      end
      it 'assign the action to the user' do
        a = Action.find(@action.id)
        expect(a.user_id).to eql @user2.id
      end
      it {should respond_with 204}
    end

    context 'the action is already assigned' do
      before do
        @action.user_id = @user.id
        @action.accepted = true
        @action.save!
        params = {id: @group.id, action_id: @action.id, user_id: @user2.id}
        api_auth_token(@user.auth_token)
        post :assign, params: params, format: :json
      end

      it 'returns an error saying already assigned' do
        expect(json_response[:errors]).to include "already assigned"
      end
      it { should respond_with 400 }
    end

    context 'non admin assigns an action' do
      before do
        params = {id: @group.id, action_id: @action.id, user_id: @user.id}
        api_auth_token(@user2.auth_token)
        post :assign, params: params, format: :json
      end
      it 'returns an error saying you are not admin' do
        expect(json_response[:errors]).to include "not admin"

      end
      it {should respond_with 401}
    end

    context 'an action does not exist' do
      before do
        params = {id: @group.id, action_id: 12021020, user_id: @user2.id}
        api_auth_token(@user.auth_token)
        post :assign, params: params, format: :json
      end
      it 'returns an error saying the action does not exist' do
        expect(json_response[:errors]).to include "not exist"

      end
      it {should respond_with 404}
    end

    context 'the user is not in group' do
      before do
        @user3 = FactoryBot.create(:user)
        params = {id: @group.id, action_id: @action.id, user_id: @user3.id}
        api_auth_token(@user.auth_token)
        post :assign, params: params, format: :json
      end
      it 'returns an error saying the user is not in group' do
        expect(json_response[:errors]).to include "not in group"

      end
      it {should respond_with 400}
    end

    context 'the user assign an action not in group' do
      before do
        @group2 = FactoryBot.create(:group)
        @action = FactoryBot.build(:action)
        @action.group = @group2
        @action.save!
        params = {id: @group.id, action_id: @action.id, user_id: @user2.id}
        api_auth_token(@user.auth_token)
        post :assign, params: params, format: :json
      end
      it 'returns an error saying the action is not in group' do
        expect(json_response[:errors]).to include "not in group"

      end
      it {should respond_with 400}
    end
  end

end
