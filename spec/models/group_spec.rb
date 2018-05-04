require 'rails_helper'

RSpec.describe Group, type: :model do

  context 'group creation' do
    before(:each) do
      @user1 = FactoryBot.build(:user)
      @user2 = FactoryBot.build(:user)
      @user3 = FactoryBot.build(:user)
      @group = FactoryBot.build(:group)
    end

    it 'Could have one or more user ' do
      @group.add_user @user1
      @group.add_user @user2
      @group.add_user @user3

      expect(@group).to be_valid
    end
  end

  it 'should have a name' do
    should validate_presence_of(:name)
  end


end
