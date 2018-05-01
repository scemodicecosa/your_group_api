class Vote < ApplicationRecord
  belongs_to :poll
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :poll_id
end
