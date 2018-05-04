class Role < ApplicationRecord

  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :user_id, scope: :group_id
  validates_presence_of :name
end
