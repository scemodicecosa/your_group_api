require 'rails_helper'

RSpec.describe Action, type: :model do
  it 'should have pefforza one group' do
    a = FactoryBot.build(:action)
    expect(a).to be_valid
  end
end
