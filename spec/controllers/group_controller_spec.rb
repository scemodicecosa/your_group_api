require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do
  before(:each) do
    @user = FactoryBot.create(:user)
  end



  context 'Create group with 5 people' do
    before(:each) do
      @group = FactoryBot.create(:group)
      api_auth_token(@user.auth_token)
      @group.add_user(@user.id,true)
      4.times do
        u = FactoryBot.create(:user)
        @group.add_user(u.id,false)
      end
    end

    it 'should have 5 members' do
      expect(@group.users.count).to eql 5
    end

  end
  describe 'GET group#show' do
    before(:each) do
      @group = FactoryBot.create(:group)
      api_auth_token(@user.auth_token)
    end
    context 'should return info about group when logged' do
      before(:each) do
        @group.add_user(@user.id,false)

        get(:show, params:{id: @group.id}, format: :json)
      end
      it {expect(json_response[:name]).to eql @group.name}
      it {expect(json_response[:description]).to eql @group.description}
      it {should respond_with 200}
    end
    context 'should not allow user to get info if not in group' do
      before(:each) do
        get(:show, params: { id: @group.id }, format: :json)
      end
      it { expect(json_response).to have_key(:errors) }
      it { expect(json_response[:errors]).to include 'You are not a member!'}
      it { should respond_with 401 }
    end
  end
  describe 'when a logged user' do
    context 'creates a right group' do
      before(:each) do
        #@user.generate_auth_token
        #@user.save!
        api_auth_token(@user.auth_token)
        @group_attributes = FactoryBot.attributes_for(:group)
        post :create, params: { group: @group_attributes }, format: :json
        @id = json_response[:id]
      end
      it 'should create a group with same info' do
        g = Group.find(@id)
        expect(g).to have_attributes @group_attributes
      end

      it 'The user should be the administrator of the group' do
        r = Role.where(group_id: @id, user_id: @user.id, admin: true).first
        expect(r).not_to be_nil
      end
      it {should respond_with 201}
    end
    context 'creates a wrong group' do
      before(:each) do
        wrong_attr = {group: {description: "mario"}}
        api_auth_token(@user.auth_token)
        post :create, params: wrong_attr, format: :json

      end
      it { expect(json_response).to have_key(:errors) }
      it { should respond_with 400 }
    end
  end
  context 'an unlogged user creates a group' do
    before(:each) do
      @group_attributes = FactoryBot.attributes_for(:group)
      post :create, params: { group: @group_attributes }, format: :json
    end
    it 'should have an error message' do
      expect(json_response).to have_key :errors
      expect(json_response[:errors]).to include "not authorized"
    end
    it { should respond_with :unauthorized}

  end
  describe 'POST @#add_user' do
    before(:each) do
      @group = FactoryBot.create(:group)
      #@user = FactoryBot.create(:user)
      @group.add_user(@user.id,true)
    end
    context 'When an admin adds a member' do
      before (:each) do
        api_auth_token(@user.auth_token)
        @user2 = FactoryBot.create(:user)
        post :add_user, params: {user_id: @user2.id, group_id: @group.id, admin: false}, format: :json
      end

      context 'should be admin if admin is called again with true' do
        before(:each) do
          post :add_user, params: {user_id: @user2.id, group_id: @group.id, admin: true}, format: :json
        end
        it { expect(Role.where(user_id: @user2.id, group_id: @group.id).first.admin).to eql true}
        it 'should be again false' do
          post :add_user, params: {user_id: @user2.id, group_id: @group.id, admin: false}, format: :json
          expect(Role.where(user_id: @user2.id, group_id: @group.id).first.admin).to eql false
        end
      end





      it 'the new user must be in group and non admin' do
        role = Role.where(group_id: @group.id, user_id: @user2.id).first
        expect(role).not_to be_nil
        expect(role.admin).to be false
      end
      it {should respond_with 204}
    end

    context 'When an admin adds an admin' do
      before(:each) do
        api_auth_token(@user.auth_token)
        @user2 = FactoryBot.create(:user)
        post :add_user, params: {user_id: @user2.id, group_id: @group.id, admin: true}, format: :json
      end

      it 'the new user must be added to the group as admin' do
        role = Role.where(group_id: @group.id, user_id: @user2.id).first
        expect(role).not_to be_nil
        expect(role.admin).to be true
      end
      it {should respond_with 204}

    end

    context 'When a non admin adds a member' do
      before(:each) do
        @nonad = FactoryBot.create(:user)
        @nonad2 = FactoryBot.create(:user)
        api_auth_token(@nonad.auth_token)
        post :add_user, params: {user_id: @nonad.id, group_id: @group.id}, format: :json
      end

      it 'should give you an error message'do
        expect(json_response).to have_key :errors
        should respond_with 401
        expect(json_response[:errors]).to include 'You are not admin'
      end
      it 'the user must not be in the group' do
        expect(@group.users).not_to include @nonad2
      end
    end

    context 'an unlogged user add a user' do
      before(:each) do

        @user2 = FactoryBot.create(:user)
        post :add_user, params: {user_id: @user2.id, group_id: @group.id, admin: true}, format: :json
      end
      it 'should have an error message' do
        expect(json_response).to have_key :errors
        expect(json_response[:errors]).to include "not authorized"
      end
      it { should respond_with :unauthorized}

    end
  end
  describe 'an user is removed' do
    before(:each) do
      @group = FactoryBot.create(:group)
      @group.add_user(@user.id,true)
      @u2 = FactoryBot.create(:user)
      @group.add_user(@u2.id,false)
    end
    context 'an admin removes an user' do
      before(:each) do
        api_auth_token(@user.auth_token)
        post :remove_user, params: {user_id: @u2.id, group_id: @group.id}, format: :json
      end

      it 'should remove the user' do
        expect(@group.users.include?(@u2)).to eql false
      end
      it { should respond_with 204}
    end

    context 'an user removes himself' do
      before(:each) do
        api_auth_token(@u2.auth_token)
        post :remove_user, params: {user_id: @u2.id, group_id: @group.id}, format: :json
      end

      it 'should remove the user' do
        expect(@group.users.include? @u2).to eql false
      end
      it { should respond_with 204}
    end

    context 'another non admin user try to remove a user' do
      before(:each) do
        @u3 = FactoryBot.create(:user)
        api_auth_token(@u3.auth_token)
        post :remove_user, params: {user_id: @u2.id, group_id: @group.id}, format: :json
      end

      it 'should get an error' do
        expect(json_response).to have_key :errors
        expect(json_response[:errors]).to include "You are not admin or in group"
      end
      it { should respond_with 401}
    end
  end

end
