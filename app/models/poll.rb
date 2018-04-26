class Poll < ApplicationRecord
  belongs_to :group
  belongs_to :user
  serialize :answers


  has_many :votes
  has_many :users, through: :votes

  validates :question, presence: true
  validates :answers, presence: true
  validates :group_id, presence: true


  def vote(u, vote)
    return unless group.users.include? u

    Vote.where(user_id: u.id, poll_id: self.id)
        .first_or_create!.update!(answer: vote)

  end


end
