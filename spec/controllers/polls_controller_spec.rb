require 'rails_helper'

RSpec.describe Api::V1::PollsController, type: :controller do
  before(:each) do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group)
    @group.add_user(@user.id, true)
    populate
  end
  describe 'POST /groups/:id/polls' do
    before(:each) do
      @attr = FactoryBot.attributes_for :poll
      api_auth_token @user.auth_token
    end

    context 'When a user creates new poll' do
      before(:each) do
        post :create, params: {group_id: @group.id, polls: @attr.without(:group)}, format: :json
      end

      it 'should create a Poll with right attributes' do
        poll = Poll.find(json_response[:id])
        expect(poll).not_to be nil
        expect(poll.user).to eql @user
        expect(poll.group_id). to eql @group.id
        expect(poll.question).to eql @attr[:question]
      end

      it { should respond_with 201 }
    end

    context 'When a user creates wrong poll' do
      before(:each) do
        post :create, params: {group_id: @group.id, polls: @attr.without(:group, :question)}, format: :json
      end

      it { expect(json_response).to have_key :errors }

      it { should respond_with 400 }
    end

    context 'when a non-admin user creates a poll' do
      before(:each) do
        u = FactoryBot.create(:user)
        @group.add_user u
        api_auth_token u.auth_token
        post :create, params: {group_id: @group.id, polls: @attr.without(:group)}, format: :json
      end

      it 'should receive an error message' do
        expect(json_response[:errors]).to include "You are not an admin"
      end
      it { should respond_with 401}
    end



  end

  describe 'GET /polls/:poll_id/vote/:vote' do
    before(:each) do
      @poll = FactoryBot.create(:poll, group: @group, user: @user)
    end

    context 'when a user vote' do
      before(:each) do
         #us = FactoryBot.create(:user)
        api_auth_token @user.auth_token
        @old_votes = @poll.votes.count
        get :vote, params:{poll_id: @poll.id, vote: 0}, format: :json
      end

      it 'poll should have a new vote' do
        expect(@old_votes + 1).to eql @poll.votes.count
      end

      it 'should return response of poll' do
        expect(json_response[0]).to have_key :answer
        expect(json_response[0]).to have_key :total
        expect(json_response[0][:total]).to eql 1
      end

      it { should respond_with 200 }
    end

    context 'when a user not in group votes' do
      before(:each) do
        us = FactoryBot.create(:user)
        api_auth_token us.auth_token
        @old_votes = @poll.votes.count
        get :vote, params:{poll_id: @poll.id, vote: 0}, format: :json
      end

      it 'should return response of poll' do
        expect(json_response).to have_key :errors
        expect(json_response[:errors]).to include "You are not in group"
      end

      it 'should not add a vote' do
        expect(@old_votes).to eql @poll.votes.count
      end

      it { should respond_with 401 }
    end

    context 'when a user vote twice' do
      before (:each) do
        api_auth_token @user.auth_token
        @old_votes = @poll.votes.count
        get :vote, params:{poll_id: @poll.id, vote: 0}, format: :json
        get :vote, params:{poll_id: @poll.id, vote: 1}, format: :json
      end

      it 'should create only one vote' do
        expect(Vote.where(poll_id: @poll.id, user_id: @user.id).count).to eql 1
      end

      it 'updates the vote' do
        expect(Vote.where(poll_id: @poll.id, user_id: @user.id).first.answer).to eql 1
      end
    end

    context 'when 10 people votes' do
      before do
        @poll.group.users.each_with_index do |user,i|
         # api_auth_token(user.auth_token)
         Vote.create(poll_id: @poll.id, user_id: user.id, answer: i % 3 % 2)
        end
      end

      it 'the polls have 10 votes' do
        expect(@poll.votes.count).to eql 10
      end

      it 'has 5 votes for answer[0]' do
        expect(@poll.get_votes[0][:total]).to eql 7
      end
    end

  end
end


def populate
  9.times do
    u = FactoryBot.create :user
    @group.add_user u.id
  end
end

