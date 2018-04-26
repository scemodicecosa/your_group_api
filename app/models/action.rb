class Action < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group

  validates :group_id, presence: true
  validates :name, presence: true
end
