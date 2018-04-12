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
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:phone_number).ignoring_case_sensitivity}
  it { should validate_confirmation_of(:password) }
  it { should allow_value('nonemail@l').for(:email)}
  it { should_not allow_value('nonemail').for(:email)}
  it { should_not respond_to(:lol) }
  it { expect(@user).to be_valid}
end
