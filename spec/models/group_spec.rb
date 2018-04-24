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
      @group.users << @user1
      @group.users << @user2
      @group.users << @user3

      expect(@group).to be_valid
    end
  end

  it 'should have a name' do
    should validate_presence_of(:name)
  end

  it 'should have at least one administrator' do

  end


end
