require 'rails_helper'

RSpec.describe User, type: :model do


  before do
    @user  = FactoryBot.build(:user)
  end

  subject { @user }

  it 'should have email' do
    should respond_to(:email)
  end
  it 'can be valid with phone and no email' do
    @user.email = ''
    @user.save
    expect(@user).to be_valid
  end
  it 'can be valid with no phone but email' do
    @user.phone_number = ''
    @user.save!
    expect(@user).to be_valid
  end

  it 'cant be valid without phone or email' do
    @user.email = ''
    @user.phone_number = ''
    @user.save
    expect(@user).not_to be_valid
  end

  it 'should coexist two user with no phone' do
    user2 = FactoryBot.build(:user)
    user2.phone_number = ''
    @user.phone_number = ''
    user2.save
    @user.save

    expect(user2).to be_valid
    expect(@user).to be_valid
  end

  it 'when delete should delete all roles associated to the user' do
    g = FactoryBot.build(:group)
    g.add_user(@user)
    id = @user.id
    @user.destroy!
    expect(Role.where(user_id: id, group_id: g.id)).to be_empty
  end

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:phone_number).ignoring_case_sensitivity}
  it { should validate_confirmation_of(:password) }
  it { should allow_value('nonemail@l').for(:email)}
  it { should_not allow_value('nonemail').for(:email)}
  it { should_not respond_to(:lol) }
  it { expect(@user).to be_valid}
end
