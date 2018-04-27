class Group < ApplicationRecord

  validates :name, presence:true
  has_many :roles
  has_many :users, through: :roles

  has_many :actions




  def add_user(user_id, admin = false)
    r = Role.where(user_id: user_id, group: self).first_or_create!
    r.update(admin: admin)
    if admin
      r.update(name: 'Admin')
    else
      r.update(name: 'Participant')
    end
  end

  def remove_user(user_id)
    Role.where(user_id: user_id, group: self).destroy_all
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
