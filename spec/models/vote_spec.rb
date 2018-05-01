require 'rails_helper'

RSpec.describe Vote, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group)
    @poll = FactoryBot.create(:poll, group_id: @group.id, user_id: @user.id)
    @vote = Vote.create(answer: 0, user_id: @user.id, poll_id: @poll.id )
    @vote2 = Vote.create(answer: 0, user_id: @user.id, poll_id: @poll.id )

  end

  it 'doesnt allow two votes from the same person' do
    expect(@vote2.errors).to_not be nil
  end
end
