require 'rails_helper'

RSpec.describe Poll, type: :model do

  context 'A user votes an answer' do

    before(:each) do
      @user = FactoryBot.build(:user)
      @user2 = FactoryBot.build(:user)
      @group = FactoryBot.build(:group)
      @group.add_user(@user)
      @poll = @group.new_poll(@user, 'Come va?', '["bene","tuttobene"]')

    end

    it 'should not create a poll if not present in group' do
      poll = @group.new_poll(@user2, 'Come va?', '["ok", "tt bn"]')
      expect(poll).to be_nil
    end

    it 'should not vote if not present in group' do
      @poll.vote(@user2,0)
      expect(Vote.where(user_id: @user.id, poll_id: @poll.id)).to be_empty
    end

    it 'should vote if present in group' do
      @poll.vote(@user, 0)
      vote = Vote.where(user_id: @user.id, poll_id: @poll.id).first
      expect(vote.answer).to be_equal 0
    end


    it 'should change his vote if has already vote' do
      @poll.vote(@user, 2)
      vote = Vote.where(user_id: @user.id, poll_id: @poll.id).first
      expect(vote.answer).to be_equal 2
    end

  end




end
