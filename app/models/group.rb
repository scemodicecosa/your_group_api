class Group < ApplicationRecord

  validates :name, presence:true
  has_many :roles
  has_many :users, through: :roles

  has_many :actions




  def add_user(id)
    Role.create!(name: 'Participant', user_id: id, group: self)
  end

  def add_admin(id)
    Role.create!(name: 'Admin', user_id: id, group: self, admin: true)
  end



  def new_poll(u, question, answers)
    return unless self.users.include? u

    Poll.create!(user: u, group:self, question: question, answers: answers)
  end

  def new_action(name, description)
    Action.create!(name: name, description: description, group: self)
  end

  def self.new_group(user, params)
    g = Group.new(params)
    g.add_admin(user)
    g
  end



end
