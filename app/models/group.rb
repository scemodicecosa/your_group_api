class Group < ApplicationRecord

  validates :name, presence:true
  has_many :roles
  has_many :users, through: :roles

  has_many :actions




  def add_user(u)
    Role.create!(name: 'Participant', user: u, group: self)
  end

  def add_admin(u)
    Role.create!(name: 'Admin', user: u, group: self, admin: true)
  end



  def new_poll(u, question, answers)
    return unless self.users.include? u

    Poll.create!(user: u, group:self, question: question, answers: answers)
  end

  def new_action(name, description)
    Action.create!(name: name, description: description, group: self)
  end



end
