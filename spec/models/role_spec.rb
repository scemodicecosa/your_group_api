require 'rails_helper'

RSpec.describe Role, type: :model do
  before do
    @group = FactoryBot.create(:group)
    @user = FactoryBot.create(:user)
  end
  it "can not creates two roles with same group id and user id" do
    r1 = Role.create(name: "ELLE", admin: false, user_id: @user.id, group_id: @group.id)
    r2 = Role.create(name: "EFFE", admin: false, user_id: @user.id, group_id: @group.id)
    expect(r2).to_not be_valid
  end
end
